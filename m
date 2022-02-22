Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2042AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiBVRVV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiBVRVU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:21:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC3D16EABA
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66520B81B84
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7078C340E8;
        Tue, 22 Feb 2022 17:20:51 +0000 (UTC)
Date:   Tue, 22 Feb 2022 12:20:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] libtracefs: Add unit tests for user_events
Message-ID: <20220222122050.4a13bcb8@gandalf.local.home>
In-Reply-To: <20220218225058.12701-4-beaub@linux.microsoft.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-4-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Feb 2022 14:50:58 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> @@ -871,6 +872,235 @@ static void test_eprobes(void)
>  	test_eprobes_instance(test_instance);
>  }
>  
> +#ifdef USEREVENTS
> +struct user_test_context {
> +	int seen;
> +	int failed;
> +};
> +static int user_callback(struct tep_event *event, struct tep_record *record,
> +			  int cpu, void *context)
> +{
> +	struct tep_format_field *field;
> +	struct user_test_context *user_context;
> +	__u32 *rel, size, offset;
> +       

The above line has extra white space.

-- Steve

> +	user_context = (struct user_test_context *)context;
> +	user_context->seen++;
> +
> +	field = tep_find_field(event, "u8");
> +	if (!field || *(__u8 *)(record->data + field->offset) != 1)
> +	{
> +		user_context->failed = 1;
> +		return -1;
> +	}
