Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85541C76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 23:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589122253D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 23:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfGWXGP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 19:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfGWXGP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 19:06:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563892238C;
        Tue, 23 Jul 2019 23:06:14 +0000 (UTC)
Date:   Tue, 23 Jul 2019 19:06:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, howaboutsynergy@pm.me
Subject: Re: [PATCH 3/3] kernel-shark: Disable Capture if trace-cmd can't
 function
Message-ID: <20190723190612.51f0011f@gandalf.local.home>
In-Reply-To: <20190723125204.22799-4-y.karadz@gmail.com>
References: <20190723125204.22799-1-y.karadz@gmail.com>
        <20190723125204.22799-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Jul 2019 15:52:04 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> In the case of an error all key buttons of the Record dialog are
> disabled.

I applied and pushed out your other two patches, but didn't apply this
one. As we discussed at our 1:1, I think it's better to at a minimum,
just disable the "Capture" button, as that's the only thing that really
needs "root". If we can't read the events or the tracers, then they
will just stay empty or set to a single default value.

No reason to disable export and import settings, the user can do that,
but it wont help them much.

-- Steve


> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsCaptureDialog.cpp | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
> index 2e6e8f9..2962917 100644
> --- a/kernel-shark/src/KsCaptureDialog.cpp
> +++ b/kernel-shark/src/KsCaptureDialog.cpp
> @@ -74,6 +74,19 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
>  		_topLayout.addWidget(errorLabel);
>  
>  		lamAddLine();
> +
> +		/* Disable all key buttons. */
> +		QVector<QWidget *> widgets =
> +			{&_importSettingsButton,
> +			 &_exportSettingsButton,
> +			 &_outputBrowseButton,
> +			 &_pluginsComboBox,
> +			 &_commandCheckBox,
> +			 &_applyButton,
> +			 &_captureButton};
> +
> +		for (auto &b: widgets)
> +			b->setDisabled(true);
>  	}
>  
>  	pluginList.prepend("nop");

