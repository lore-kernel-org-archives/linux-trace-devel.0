Return-Path: <SRS0=HcHG=4Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4997C3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 23:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA9D246B6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 23:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1XSK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB1XSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 18:18:10 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2D1246B4;
        Fri, 28 Feb 2020 23:18:09 +0000 (UTC)
Date:   Fri, 28 Feb 2020 18:18:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] trace-cmd: Save the tracee address map into the
 trace.dat file.
Message-ID: <20200228181807.5d9f9636@gandalf.local.home>
In-Reply-To: <20190828112457.10533-3-tz.stoyanov@gmail.com>
References: <20190828112457.10533-1-tz.stoyanov@gmail.com>
        <20190828112457.10533-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 14:24:56 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -2223,9 +2385,6 @@ static int handle_options(struct tracecmd_input *handle)
>  		case TRACECMD_OPTION_UNAME:
>  			handle->uname = strdup(buf);
>  			break;
> -		case TRACECMD_OPTION_VERSION:
> -			handle->version = strdup(buf);
> -			break;

I've been wondering why I've been getting "unknown option 9" for some time.
Was there any reason to remove this?

-- Steve


>  		case TRACECMD_OPTION_HOOK:
>  			hook = tracecmd_create_event_hook(buf);
>  			hook->next = handle->hooks;
> @@ -2235,6 +2394,10 @@ static int handle_options(struct tracecmd_input *handle)
