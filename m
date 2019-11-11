Return-Path: <SRS0=zoIR=ZD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E24C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9416D21872
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKKWr5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 17:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbfKKWr5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 17:47:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F87B214DB;
        Mon, 11 Nov 2019 22:47:56 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:47:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     vincent.donnefort@arm.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Enable kptr_restrict
Message-ID: <20191111174754.47651068@gandalf.local.home>
In-Reply-To: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Vincent!


On Thu,  7 Nov 2019 10:51:05 +0000
vincent.donnefort@arm.com wrote:

> From: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> kptr_restrict might prevent trace-cmd from accessing /proc/kallsyms,
> leading to a trace without the kernel function names resolved.
> 
> Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 41932ee..3c4f306 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -674,6 +674,39 @@ static int read_event_files(struct tracecmd_output *handle,
>  	return ret;
>  }
>  
> +static void set_proc_kptr_restrict(int reset)
> +{
> +	char *path = "/proc/sys/kernel/kptr_restrict";

I believe this is a relatively new file. We should do a stat to see if
it exists, and if it does not, simply fail silently. I don't think we
want to give a warning if the file doesn't exist because the kernel
doesn't have it.

> +	static char saved = 'X';
> +	int fd, ret = -1;
> +	char buf;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		goto err;
> +
> +	if (reset) {
> +		buf = saved;
> +	} else {
> +		if (read(fd, &buf, 1) < 0)
> +			goto err;
> +		saved = buf;
> +		buf = '0';
> +	}
> +	close(fd);
> +

Perhaps if reset is true and buf == 'X', we should simply exit, as it
would appear that we never put anything into buf. And probably should
make the 'X' a macro:

#define KPTR_UNINITIALIZED	'X'

	static char saved = KPTR_UNINITIALIZED;

[..]

	if (reset && buf == KPTR_UNINITIALIZED)
		return;


-- Steve

> +	fd = open(path, O_WRONLY);
> +	if (fd < 0)
> +		goto err;
> +	if (write(fd, &buf, 1) > 0)
> +		ret = 0;
> +err:
> +	if (fd > 0)
> +		close(fd);
> +	if (ret)
> +		warning("can't set kptr_restrict");
> +}
> +
>  static int read_proc_kallsyms(struct tracecmd_output *handle,
>  			      const char *kallsyms)
>  {
> @@ -698,12 +731,16 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
>  	endian4 = convert_endian_4(handle, size);
>  	if (do_write_check(handle, &endian4, 4))
>  		return -1;
> +
> +	set_proc_kptr_restrict(0);
>  	check_size = copy_file(handle, path);
>  	if (size != check_size) {
>  		errno = EINVAL;
>  		warning("error in size of file '%s'", path);
> +		set_proc_kptr_restrict(1);
>  		return -1;
>  	}
> +	set_proc_kptr_restrict(1);
>  
>  	return 0;
>  }

