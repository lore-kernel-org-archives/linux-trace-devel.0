Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8536CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B426222C5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405714AbfJROcl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbfJROcl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 10:32:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 747AA222C5;
        Fri, 18 Oct 2019 14:32:40 +0000 (UTC)
Date:   Fri, 18 Oct 2019 10:32:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Do not save the settings when running
 as Root
Message-ID: <20191018103238.3b3877cb@gandalf.local.home>
In-Reply-To: <20191018074722.6976-2-y.karadz@gmail.com>
References: <20191018074722.6976-1-y.karadz@gmail.com>
        <20191018074722.6976-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Oct 2019 10:47:21 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Do not save the settings if KernelShark is running with Root privileges.
> Otherwise the configuration file will be owned by Root and later the
> normal user will have no access to it.

Perhaps we should have the settings saved in the root home directory?

Reason being, I run kernelshark as root all the time (on my test boxes,
where I only log in as root).

And I would still like to have the settings saved. Maybe check if the
settings path is the same as $HOME variable?

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 3402764..6da8670 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -152,9 +152,15 @@ KsMainWindow::~KsMainWindow()
>  					_session.getConfDocPtr());
>  	}
>  
> -	_settings.setValue("dataPath", _lastDataFilePath);
> -	_settings.setValue("confPath", _lastConfFilePath);
> -	_settings.setValue("pluginPath", _lastPluginFilePath);
> +	/*
> +	 * Do not save the settings if KernelShark is running with Root
> +	 * privileges. Otherwise the configuration file will be owned by Root.
> +	 */
> +	if (geteuid() != 0) {
> +		_settings.setValue("dataPath", _lastDataFilePath);
> +		_settings.setValue("confPath", _lastConfFilePath);
> +		_settings.setValue("pluginPath", _lastPluginFilePath);
> +	}
>  
>  	_data.clear();
>  

