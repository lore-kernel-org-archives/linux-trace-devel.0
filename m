Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbeK1Hoz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 02:44:55 -0500
Date: Tue, 27 Nov 2018 15:45:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 08/11] kernel-shark qt: No error when Record
 authentication dialog is closed
Message-ID: <20181127154545.620ca135@gandalf.local.home>
In-Reply-To: <20181121151356.16901-10-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
        <20181121151356.16901-10-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 21 Nov 2018 15:14:26 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> No error message must be shown in the case when the user dismissed
> the authentication dialog (clicked Cancel).
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsMainWindow.cpp | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsMainWindow.cpp
> index ffb10d4..d5b22dc 100644
> --- a/kernel-shark-qt/src/KsMainWindow.cpp
> +++ b/kernel-shark-qt/src/KsMainWindow.cpp
> @@ -965,6 +965,14 @@ void KsMainWindow::_captureFinished(int exit, QProcess::ExitStatus st)
>  
>  	_captureLocalServer.close();
>  
> +	if (exit == 126) {

Can we make a define for than number?

Thanks,

-- Steve

> +		/*
> +		 * Authorization could not be obtained because the user
> +		 * dismissed the authentication dialog.
> +		 */
> +		return;
> +	}
> +
>  	if (exit != 0 || st != QProcess::NormalExit) {
>  		QString message = "Capture process failed:<br>";
>  
