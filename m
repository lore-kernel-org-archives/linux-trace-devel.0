Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6EDC76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 06:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562DE21743
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 06:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpiL8McK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfGQG4D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 02:56:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54496 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQG4D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 02:56:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so20910077wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Jul 2019 23:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3+XErwZ34BplpJXQQ8/RkBKUYhzmEpLcAeQwjiV0pxk=;
        b=QpiL8McKBIppbcC1dfqPnhNjsIf+5jS05E7WvMKaATqr5IOd9Rdv3TZTP9mxu7dB6w
         WSgmVT4AAsyoDJ23kkadlEHnO4S2exgYR0HrK0Byp10M9xiRXMJjjMUvTmki9bly4Cdz
         k5s6TKP2CBPqGKp42237+vLxNFpns/62mMh49AruLxybMpZFIwTw0EUCQeva5sDM3wGw
         WWDaHlbeVZrpMvbI8TyD3gDxyWH+efTVWZeSwPPPRug+ESSjOyS0J6Be3Q5uC8ey0+4v
         6G619djfM27okN7qnyhxcbFgG/MlYEWZQLz6QTmWB6tjoL63JnOKRtasZnRVhOwTN3u4
         mLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3+XErwZ34BplpJXQQ8/RkBKUYhzmEpLcAeQwjiV0pxk=;
        b=b5Z/VpPMzGcT02I7gk4eesF3t41iQ2gOS+BBs5ddyvw4agRa124VtsHhBKVoHu1rAV
         Tzs1tOPy+ZoujPvo6YMo1mfCyvSDqqxDAtJZvhNeRyYIcS4nf+63V92g4qJRcmMT/WAn
         51L6mozXgcQh8SZqfRjm+pMknsx+KZsTAMolPIt9+kWKS49xlZ7axLDIai51zyNqsCex
         wtQHotXvW+Y04nZo7yo1k5obsijm7VQuzD3JfVUNFycXvjObTDSJZ4XweHyjLTqoa+NT
         334T3+c2Fquq7sNjyMhCkaedWg7OD43PFYQGlFe3XTOx3l4Dc0eN59o/iyWDM5esoKEc
         BCsA==
X-Gm-Message-State: APjAAAXkP5F5qCQidhF9DOHAiqMJlJXmnsHt6k2bwaAfUWZL3UqeIs5g
        kTZktnmPAPXA27muxVrW4kysfP2Ng8I=
X-Google-Smtp-Source: APXvYqwib9UuNwAwjA7Ug58o+lXngNbJ+D5n+Sm9pAL2dioSGEC7PV8L5+2S24D/FLcfXoBJ/pDmOw==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr35597012wmb.129.1563346561704;
        Tue, 16 Jul 2019 23:56:01 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g8sm24223596wme.20.2019.07.16.23.56.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 23:56:00 -0700 (PDT)
Subject: Re: [PATCH 4/4] kernel-shark: Use <br> for dialog and \n for console
 error messages
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190710134636.116362181@goodmis.org>
 <20190710134725.599995325@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <53f66061-89a4-8d81-f618-ef3a7b573517@gmail.com>
Date:   Wed, 17 Jul 2019 09:55:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710134725.599995325@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 10.07.19 г. 16:46 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The Qt dialog boxes require '<br>' to print a new line but consoles require
> a '\n'. Instead of printing '<br>' to the console or '\n' to the dialog,
> always have the '\n' turn into '<br>' for the dialog and all '<br>' turn
> into '\n' for the console.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/src/KsMainWindow.cpp | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 54aa6d782ad1..29d44d9a9230 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -1028,10 +1028,12 @@ void KsMainWindow::loadDataFile(const QString& fileName)
>   	}
>   }
>   
> -void KsMainWindow::_error(const QString &text, const QString &errCode,
> +void KsMainWindow::_error(const QString &mesg, const QString &errCode,
>   			  bool resize, bool unloadPlugins)
>   {
>   	QErrorMessage *em = new QErrorMessage(this);
> +	QString text = mesg;
> +	QString html = mesg;
>   
>   	if (resize)
>   		_resizeEmpty();
> @@ -1039,8 +1041,11 @@ void KsMainWindow::_error(const QString &text, const QString &errCode,
>   	if (unloadPlugins)
>   		_plugins.unloadAll();
>   
> +	text.replace("<br>", "\n", Qt::CaseInsensitive);
> +	html.replace("\n", "<br>", Qt::CaseInsensitive);
> +
>   	qCritical().noquote() << "ERROR: " << text;
> -	em->showMessage(text, errCode);
> +	em->showMessage(html, errCode);
>   	em->exec();
>   }
>   
> 

All patches look good to me.
Thanks!
Yordan

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>


