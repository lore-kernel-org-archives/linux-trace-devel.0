Return-Path: <SRS0=DbCI=BH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33CFC433E8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB3A206F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgG1N0o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbgG1N0o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 09:26:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB7F206D7;
        Tue, 28 Jul 2020 13:26:43 +0000 (UTC)
Date:   Tue, 28 Jul 2020 09:26:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] KernelShark: Fix combo plot plugin crash in case of
 multiple streams
Message-ID: <20200728092642.31345031@oasis.local.home>
In-Reply-To: <20200727071823.169962-4-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
        <20200727071823.169962-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 27 Jul 2020 10:18:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> Added a check if there is a host-guest mapping in the loaded
> multiple streams. If there is no such mapping, print an error and
> exit the KsComboPlotDialog::update() function.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>  src/plugins/KVMCombo.cpp | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
> index ceb1f47..3ec36b6 100644
> --- a/src/plugins/KVMCombo.cpp
> +++ b/src/plugins/KVMCombo.cpp
> @@ -246,7 +246,12 @@ void KsComboPlotDialog::update()
>  	_guestMap = nullptr;
>  	_guestMapCount = 0;
>  	ret = kshark_tracecmd_get_hostguest_mapping(&_guestMap);
> -	if (ret > 0)
> +	if (ret <= 0) {
> +		QString err("Cannot find host / guest tracing into the loaded streams");
> +		QMessageBox msgBox;
> +		msgBox.critical(nullptr, "Error", err);
> +		return;
> +	} else
>  		_guestMapCount = ret;
>

Just a nit, but if we are following Linux coding styles, the above
should be:

	if (ret <= 0) {
		[..]
	} else {
		_guestMapCount = ret;
	}

As it is looked down upon to have part of an if block have brackets and
another part without. But I'll leave that up to Yordan to decide ;-)

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>


-- Steve
 
>  	KsUtils::setElidedText(&_hostFileLabel,

