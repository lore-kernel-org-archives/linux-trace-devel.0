Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA09C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BACF6613D2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhEDUXE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 May 2021 16:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhEDUXD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 May 2021 16:23:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EB3613CF;
        Tue,  4 May 2021 20:22:08 +0000 (UTC)
Date:   Tue, 4 May 2021 16:22:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] libtraceevent: Rename tep_vwarning() to
 tep_vprint()
Message-ID: <20210504162206.1c3368fd@gandalf.local.home>
In-Reply-To: <20210428073001.755905-4-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
        <20210428073001.755905-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 10:30:00 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -24,11 +24,11 @@ void tep_set_loglevel(enum tep_loglevel level)
>  	log_level = level;
>  }
>  
> -int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
> +int __weak tep_vprint(const char *name, enum tep_loglevel level, const char *fmt, va_list ap)
>  {
>  	int ret = errno;
>  
> -	if (errno)
> +	if (errno && level <= TEP_LOG_WARNING)
>  		perror(name);
>  
>  	fprintf(stderr, "  ");

If this is passing in a log level, why not just have:

	if (level < loglevel)
		return 0;

?

-- Steve
