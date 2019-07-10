Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73407C73C63
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 01:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4450520693
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 01:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGJBgU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 21:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfGJBgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 21:36:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B767220693;
        Wed, 10 Jul 2019 01:36:18 +0000 (UTC)
Date:   Tue, 9 Jul 2019 21:36:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/8] kernel-shark: remove the "make install" suggestion
 for capture errors
Message-ID: <20190709213617.30fb014b@gandalf.local.home>
In-Reply-To: <20190709155650.2345-7-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
        <20190709155650.2345-7-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  9 Jul 2019 18:56:48 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The message is not appropriate, although it is most likely that the
> error occurs because the user didn't install KernelShark and it runs
> the executable from its build location.=

I don't believe it is most likely, as I hit this error several times and
that wasn't the solution.

But we need to have an error stating what was missing.

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 752a17a..3f238db 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -1154,8 +1154,6 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
>  	QString message = "Capture process failed:<br>";
>  
>  	message += capture->errorString();
> -	message += "<br>Try doing:<br> sudo make install";
> -
>  	_error(message, "captureFinishedErr", false, false);
>  }
>  

