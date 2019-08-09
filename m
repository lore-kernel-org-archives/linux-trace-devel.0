Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3C6C433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0632171F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407000AbfHINTR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406938AbfHINTR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:19:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8BE21743;
        Fri,  9 Aug 2019 13:19:15 +0000 (UTC)
Date:   Fri, 9 Aug 2019 09:19:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
Subject: Re: [PATCH 1/3] kernel-shark: Show warning message when running as
 Root
Message-ID: <20190809091914.75f553b2@gandalf.local.home>
In-Reply-To: <20190809080623.7548-2-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
        <20190809080623.7548-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Aug 2019 11:06:21 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Running the KernelShark GUI with Root privileges is not recommended due
> to security reasons. The user will be allowed to continue on its own risk.
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204475
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 28 ++++++++++++++++++++++++++++
>  kernel-shark/src/KsMainWindow.hpp |  2 ++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 6439265..2560bf8 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -76,6 +76,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>  	_createMenus();
>  	_initCapture();
>  
> +	if (geteuid() == 0)
> +		_rootWarning();
> +
>  	_splitter.addWidget(&_graph);
>  	_splitter.addWidget(&_view);
>  	setCentralWidget(&_splitter);
> @@ -1271,3 +1274,28 @@ void KsMainWindow::_deselectB()
>  	_mState.updateLabels();
>  	_graph.glPtr()->model()->update();
>  }
> +
> +void KsMainWindow::_rootWarning()
> +{
> +	QString cbFlag("noRootWorn");

Mike already pointed this out (Thanks Mike!)

> +
> +	if (_settings.value(cbFlag).toBool())
> +		return;
> +
> +	QMessageBox warn;
> +	warn.setText("KernelShark will have Root privileges.");
> +	warn.setInformativeText("Continue on your one risk.");

Probably better to say:

  "KernelShark is running with Root privileges."
  "Continue at your own risk."

-- Steve

> +	warn.setIcon(QMessageBox::Warning);
> +	warn.setStandardButtons(QMessageBox::Close);
> +
> +	QCheckBox cb("Don't show this message again.");
> +
> +	auto lamCbChec = [&] (int state) {
> +		if (state)
> +			_settings.setValue(cbFlag, true);
> +	};
> +
> +	connect(&cb, &QCheckBox::stateChanged, lamCbChec);
> +	warn.setCheckBox(&cb);
> +	warn.exec();
> +}
> diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
> index 62e66a0..4a7b8ab 100644
> --- a/kernel-shark/src/KsMainWindow.hpp
> +++ b/kernel-shark/src/KsMainWindow.hpp
> @@ -238,6 +238,8 @@ private:
>  
>  	void _deselectB();
>  
> +	void _rootWarning();
> +
>  	void _updateFilterMenu();
>  
>  	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);

