Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B76C433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CE3214C6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436480AbfHINdp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436490AbfHINdo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:33:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78AB214C6;
        Fri,  9 Aug 2019 13:33:42 +0000 (UTC)
Date:   Fri, 9 Aug 2019 09:33:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
Subject: Re: [PATCH 2/3] kernel-shark: Don't use pkexec when running as Root
Message-ID: <20190809093341.0936f336@gandalf.local.home>
In-Reply-To: <20190809080623.7548-3-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
        <20190809080623.7548-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Aug 2019 11:06:22 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> If KernelShark GUI has been started as Root we do not need to use
> "pkexec" when starting the Record dialog. Note that the actual place
> where "pkexec" gets used is in the script "kshark-su-record".
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 47 +++++++++++++++++++++----------
>  1 file changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 2560bf8..e9c6d54 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -883,23 +883,26 @@ void KsMainWindow::_pluginAdd()
>  
>  void KsMainWindow::_record()
>  {
> -#ifndef DO_AS_ROOT
> +	bool canDoAsRoot(false);

Is this the C++ way of doing:

	bool canDoAsRoot = false; ?
>  
> -	QErrorMessage *em = new QErrorMessage(this);
> -	QString message;
> -
> -	message = "Record is currently not supported.";
> -	message += " Install \"pkexec\" and then do:<br>";
> -	message += " cd build <br> sudo ./cmake_uninstall.sh <br>";
> -	message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
> -	message += " sudo make install";
> +#ifdef DO_AS_ROOT

BTW, I think we should rename DO_AS_ROOT to "HAS_PKEXEC" as that is
much more descriptive of what that macro means.

> +	canDoAsRoot = true;
> +#endif
>  
> -	em->showMessage(message);
> -	qCritical() << "ERROR: " << message;
> +	if (geteuid() && !canDoAsRoot) {
> +		QErrorMessage *em = new QErrorMessage(this);
> +		QString message;
>  
> -	return;
> +		message = "Record is currently not supported.";
> +		message += " Install \"pkexec\" and then do:<br>";
> +		message += " cd build <br> sudo ./cmake_uninstall.sh <br>";
> +		message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
> +		message += " sudo make install";
>  
> -#endif
> +		em->showMessage(message);
> +		qCritical() << "ERROR: " << message;
> +		return;
> +	}
>  
>  	_capture.start();
>  }
> @@ -1134,9 +1137,24 @@ void KsMainWindow::loadSession(const QString &fileName)
>  
>  void KsMainWindow::_initCapture()
>  {
> +	bool canDoAsRoot(false);
> +
>  #ifdef DO_AS_ROOT
> +	canDoAsRoot = true;
> +#endif

As we are repeating this, why not just do at the top of the file:

#ifdef HAS_PKEXEC
# define has_pkexec 1
#else
# define has_pkexec 0
#endif

And remove the deplicate logic.

> +
> +	if (geteuid() && !canDoAsRoot)
> +		return;
>  
> -	_capture.setProgram("kshark-su-record");
> +	if (geteuid()) {

Also, "geteuid()" is a system call. It causes a call to the kernel each
time. We should cache that in a local variable instead, and use that.

	uid_t euid = geteuid();

Then use "euid" for other locations. But its OK to calculated it in the
function itself. That is, don't use the value from a different
function, as we don't want to worry about adding commands that change
the euid later.

-- Steve


> +		_capture.setProgram("kshark-su-record");
> +	} else {
> +		QStringList argv;
> +
> +		_capture.setProgram("kshark-record");
> +		argv << QString("-o ") + QDir::homePath();
> +		_capture.setArguments(argv);
> +	}
>  
>  	connect(&_capture,	&QProcess::started,
>  		this,		&KsMainWindow::_captureStarted);
> @@ -1155,7 +1173,6 @@ void KsMainWindow::_initCapture()
>  	connect(&_captureLocalServer,	&QLocalServer::newConnection,
>  		this,			&KsMainWindow::_readSocket);
>  
> -#endif
>  }
>  
>  void KsMainWindow::_captureStarted()

