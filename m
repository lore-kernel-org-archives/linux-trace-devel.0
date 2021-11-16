Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF496C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 21:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E1161BBD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 21:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhKPVOw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Nov 2021 16:14:52 -0500
Received: from linux.microsoft.com ([13.77.154.182]:35934 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPVOw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 16:14:52 -0500
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id ACE1720C5A74;
        Tue, 16 Nov 2021 13:11:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACE1720C5A74
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637097114;
        bh=sofdJFiZhl9TUfK+xChDT/3l6fcc8nPvIZS/rPjKrUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e9c8enXQW6eQ9yW5rKhNd+eDWwh+7y1SF4CLqDP8V+Qn0HZQMvRhWPYdFzfwLLQB7
         Q9NTdymRzv1wY1AYe+cpf30VYZ1P0y2XmwuByWAkMSGQTD7t0z2hxbjAdjlzJfSNuA
         rFIdah644nGinZY//TPtjFSX97kScS5CLbQgLTqs=
Date:   Tue, 16 Nov 2021 13:11:50 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/12] user_events: Validate user payloads for size
 and null termination
Message-ID: <20211116211150.GA2337@kbox>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
 <20211116005047.1808-13-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116005047.1808-13-beaub@linux.microsoft.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 15, 2021 at 04:50:47PM -0800, Beau Belgrave wrote:
> +static int user_event_validate(struct user_event *user, void *data, int len)
> +{
> +	struct list_head *head = &user->validators;
> +	struct user_event_validator *validator;
> +	void *pos, *end = data + len;
> +	u16 *val, offset, size;
> +
> +	list_for_each_entry(validator, head, link) {
> +		pos = data + validator->offset;
> +		val = pos;
> +
> +		/* Already done min_size check, no bounds check here */
> +		offset = *val++;
> +		size = *val++;

I believe I have these backwards, size should come first for both dyn
and rel data. Is this correct?

> diff --git a/tools/testing/selftests/user_events/ftrace_test.c b/tools/testing/selftests/user_events/ftrace_test.c
> index 9d53717139e6..bea694e9df8c 100644
> --- a/tools/testing/selftests/user_events/ftrace_test.c
> +++ b/tools/testing/selftests/user_events/ftrace_test.c
> @@ -21,6 +21,11 @@ const char *status_file = "/sys/kernel/debug/tracing/user_events_status";
>  const char *enable_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/enable";
>  const char *trace_file = "/sys/kernel/debug/tracing/trace";
>  
> +struct rel_loc {
> +	__u16 offset;
> +	__u16 size;
> +} __packed;
> +

Same here.

Thanks,
-Beau
