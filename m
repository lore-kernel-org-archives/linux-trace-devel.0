Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E735C77B61
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Apr 2023 19:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjDXTqM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Apr 2023 15:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXTqL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Apr 2023 15:46:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199755B8C
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Apr 2023 12:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A61FD62189
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Apr 2023 19:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D31C433D2;
        Mon, 24 Apr 2023 19:46:08 +0000 (UTC)
Date:   Mon, 24 Apr 2023 15:45:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] libtracefs: Unit test for tracefs_instance_reset()
Message-ID: <20230424154557.28f371f7@rorschach.local.home>
In-Reply-To: <20230328150308.34783-4-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
        <20230328150308.34783-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Mar 2023 18:03:08 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The logic of the tracefs_instance_reset() is complex and should be
> covered by the unit tests of the tracefs library.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  utest/tracefs-utest.c | 183 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index e0e3c07..5866339 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -1618,6 +1618,187 @@ static void test_instance_file(void)
>  	free(inst_dir);
>  }
>  
> +static bool test_check_file_contetnt(struct tracefs_instance *instance, char *file,

Misspelling of "content"

> +				     char *content, bool full_match, bool ignore_comments)
> +{
> +	char *save = NULL;
> +	char *buf, *line;
> +	bool ret = false;
> +	int len;
> +
> +	if (!tracefs_file_exists(instance, file))
> +		return false;
> +
> +	buf = tracefs_instance_file_read(instance, file, NULL);
> +	if (strlen(content) == 0) {
> +		/* check for empty file */
> +		if (!buf)
> +			return true;
> +		if (!ignore_comments) {
> +			if (strlen(buf) > 0)
> +				goto out;
> +		} else {
> +			line = strtok_r(buf, "\n", &save);
> +			while (line) {
> +				if (line[0] != '#')
> +					goto out;
> +				line = strtok_r(NULL, "\n", &save);
> +			}
> +		}
> +	} else {
> +		if (!buf || strlen(buf) < 1)
> +			return false;
> +		if (full_match) {
> +			/* strip the newline */
> +			len = strlen(buf)-1;

Let's keep with the linux style of spaces between operands:

  strlen(buf) - 1;

> +			while (buf[len] == '\n' || buf[len] == '\r') {
> +				buf[len] = '\0';
> +				len = strlen(buf)-1;

Here too.

> +				if (len < 0)
> +					goto out;
> +			}
> +			if (strcmp(buf, content))
> +				goto out;
> +		} else {
> +			if (!strstr(buf, content))
> +				goto out;
> +		}
> +	}
> +
> +	ret = true;
> +out:
> +	free(buf);
> +	return ret;
> +}
> +
> +static bool test_check_event_file_contetnt(struct tracefs_instance *instance,

Misspelled "content".


-- Steve

> +					   char *system, char *event, char *file,
> +					   char *content, bool full_match, bool ignore_comments)
> +{
> +	char *efile;
> +	int ret;
> +
> +	ret = asprintf(&efile, "events/%s/%s/%s", system, event, file);
> +	if (ret <= 0)
> +		return false;
> +	ret = test_check_file_contetnt(instance, efile, content, full_match, ignore_comments);
> +	free(efile);
> +	return ret;
> +}
> +
> +static bool check_cpu_mask(struct tracefs_instance *instance)
