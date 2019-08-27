Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1AEC3A5A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E185214DA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfH0XDE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfH0XDE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 19:03:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C51E214DA;
        Tue, 27 Aug 2019 23:03:02 +0000 (UTC)
Date:   Tue, 27 Aug 2019 19:03:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
Subject: Re: [PATCH v2 5/5] kernel-shark: Better formatting of the error
 messages from "Record"
Message-ID: <20190827190301.43fad2d3@gandalf.local.home>
In-Reply-To: <20190826155811.32021-6-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
        <20190826155811.32021-6-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Aug 2019 18:58:11 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Make the message easier to read and understand by separating the
> QProcess's error and the Standard error.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 651cf59..a3b5ce7 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -1211,9 +1211,10 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
>  
>  void KsMainWindow::_captureErrorMessage(QProcess *capture)
>  {
> -	QString message = "Capture process failed:<br>";
> +	QString message = "Capture process failed: ";
>  
>  	message += capture->errorString();
> +	message += "<br>Standard Error :";

I changed the above to: "<br>Standard Error: ", as I added:

 echo "this is an error" >&2
 exit 1

to kshark-su-record and the current patch produces:

  ERROR:  Capture process failed: Unknown error
  Standard Error :this is an error

Where I think the below looks better:

  ERROR:  Capture process failed: Unknown error
  Standard Error: this is an error

-- Steve


>  	message += capture->readAllStandardError();
>  	_error(message, "captureFinishedErr", false, false);
>  }

