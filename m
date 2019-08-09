Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DB0C31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E1AB214C6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfHINfy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfHINfy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:35:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A3D214C6;
        Fri,  9 Aug 2019 13:35:52 +0000 (UTC)
Date:   Fri, 9 Aug 2019 09:35:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
Subject: Re: [PATCH 3/3] kernel-shark: Use standart error message in
 KsMainWindow::_record()
Message-ID: <20190809093551.73e7f06c@gandalf.local.home>
In-Reply-To: <20190809080623.7548-4-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
        <20190809080623.7548-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Aug 2019 11:06:23 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

Typo in subject "standard".

Other than that, it looks good.

-- Steve


> The error message is printed using the method KsMainWindow::_error().
> The message itself remains unchanged. If we want to change the message,
> this can be done in another patch.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index e9c6d54..b462ded 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -890,7 +890,6 @@ void KsMainWindow::_record()
>  #endif
>  
>  	if (geteuid() && !canDoAsRoot) {
> -		QErrorMessage *em = new QErrorMessage(this);
>  		QString message;
>  
>  		message = "Record is currently not supported.";
> @@ -899,8 +898,7 @@ void KsMainWindow::_record()
>  		message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
>  		message += " sudo make install";
>  
> -		em->showMessage(message);
> -		qCritical() << "ERROR: " << message;
> +		_error(message, "recordCantStart", false, false);
>  		return;
>  	}
>  

