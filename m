Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983A2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58579613D8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 20:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhEDUZW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 May 2021 16:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhEDUZW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 May 2021 16:25:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB8E61059;
        Tue,  4 May 2021 20:24:26 +0000 (UTC)
Date:   Tue, 4 May 2021 16:24:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] libtraceevent: Add logs with severity info
Message-ID: <20210504162425.5cced88c@gandalf.local.home>
In-Reply-To: <20210428073001.755905-3-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
        <20210428073001.755905-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 10:29:59 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  void tep_info(const char *fmt, ...)
>  {
>  	va_list ap;
>  
>	if (log_level < TEP_LOG_INFO)
>		return;
>  
>  	va_start(ap, fmt);
>	tep_vprint("libtraceevent", TEP_LOG_INFO fmt, ap);
>  	va_end(ap);
>  }

The above should just be:

void tep_info(const char *fmt, ...)
{
	va_list ap;

 	va_start(ap, fmt);
	tep_vprint("libtraceevent", TEP_LOG_INFO fmt, ap);
 	va_end(ap);
}

And let the tep_vprint() decide to print it or not.

-- Steve
