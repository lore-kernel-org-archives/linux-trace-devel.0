Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D0CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  8 Oct 2022 15:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJHPkU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 8 Oct 2022 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJHPkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 8 Oct 2022 11:40:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4115E1903F
        for <linux-trace-devel@vger.kernel.org>; Sat,  8 Oct 2022 08:40:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so11158313wrp.10
        for <linux-trace-devel@vger.kernel.org>; Sat, 08 Oct 2022 08:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UhtJFihhdJA+2vEXeCr11wW4DObRPWWvFq21iQW+NTs=;
        b=MbuDfkYPhozWqDFqOJ5h57CN3bNLAhQ4RBbeDY6jwQR3Td0UH+JCNHdK16uG2TJs1i
         IoD/rRKiYI1kuxqACuMktsfenmwTGFPyi25fAK8qesEk3cVXai+RSZcSVMIm1ziolqZ7
         fJQdNDuC98Bw4iUWLot1tOOzQ7JX8c4dblMj+aljs3c6H30NY6YsRg5QaoFtA/FCCWGV
         uFIfm/KDOZNh39d9PpxZ971y1hQ3wfStlNAPGHKIq5YShmW0sdflQXM9SIHpbVQ7636e
         88Pkg/1Wc18s8Y4O48qTvEbCh7mZXP8ezKm8S61BUNtZnijnml73RSLq0Ky5YvzL8/fU
         Kvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UhtJFihhdJA+2vEXeCr11wW4DObRPWWvFq21iQW+NTs=;
        b=uKX/HIyB9bUqKyOWod6a6M7xzwSKS88WFMEPBo5VW4iINlxbMwm/VQZiGlMPT6aQJq
         SR8f8SnelzbFoPZQQNU/LlpAWQAgfu74dUR5bIr5+2MzNdd3yyqEpekFqATRcLkTW4sf
         xfb4GgMGf7+ocY/HFYzM8WemUXzGSqULQq/N3AW8O+82pu2KjO4cdk3ISB0Vg75gAQnW
         jA6Lidieq71sCF7IdFPk9HyxbEMTcRIQtS1TjjCvfNWbbZr9zt1A2zXhtKmUCW9GlEIx
         PeUaO448EBNacuMwCs4I/jewdY7ao2cpfDDaj21gFx5RZSE+ELpSoNppYCHUyRdwE+TZ
         75iw==
X-Gm-Message-State: ACrzQf02MAWQIk2r0dyj/xgGf1Yg8oALTCfBjCVmmKbyuB2ysfsuN9zD
        fiN1FSpGEQFKi9YjHYIcZ971/E1EruI=
X-Google-Smtp-Source: AMsMyM6DhjEZsGiKEyWqz7tc+q5Xw6jarCUxjrWjggQtyvyTp3RRhSQTI6MFgJb9hLIYja54DcGtLA==
X-Received: by 2002:adf:f78a:0:b0:22e:5611:d8a2 with SMTP id q10-20020adff78a000000b0022e5611d8a2mr6402793wrp.449.1665243615561;
        Sat, 08 Oct 2022 08:40:15 -0700 (PDT)
Received: from [192.168.1.8] (78-154-13-219.ip.btc-net.bg. [78.154.13.219])
        by smtp.gmail.com with ESMTPSA id e15-20020a05600c4e4f00b003c586bff0e6sm123677wmq.14.2022.10.08.08.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Oct 2022 08:40:14 -0700 (PDT)
Message-ID: <e7d94022-bd8e-67dd-0a0e-fcd7eed43f09@gmail.com>
Date:   Sat, 8 Oct 2022 18:40:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] kernel-shark: Fix function_graph indent monospace
To:     Andrej Stender <andrej.stender@thermalcircle.de>,
        linux-trace-devel@vger.kernel.org
References: <ce193c5260178313eaaab3dcf49dfcbb9526be0b.1664810553.git.andrej.stender@thermalcircle.de>
Content-Language: en-US
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <ce193c5260178313eaaab3dcf49dfcbb9526be0b.1664810553.git.andrej.stender@thermalcircle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied. Thanks Andrej!
Yordan


On 10/3/22 18:40, Andrej Stender wrote:
> Show content of KsTraceViewer table in monospaced font. When using
> function_graph tracer, its C-style indentation of traced functions is
> now shown correctly.
> 
> Use system font, so the font used in the table can still can be
> configured via window manager, same as the fonts in title and menus. The
> font in the horizontal header of the table stays regular non-monospaced
> as before.
> 
> Tested on KDE Plasma 5.25.4, Qt 5.15.4.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216404
> Signed-off-by: Andrej Stender <andrej.stender@thermalcircle.de>
> ---
>   src/KsTraceViewer.cpp | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
> index afd5a859de72..be0a41941db2 100644
> --- a/src/KsTraceViewer.cpp
> +++ b/src/KsTraceViewer.cpp
> @@ -129,6 +129,9 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
>   	_view.setSelectionBehavior(QAbstractItemView::SelectRows);
>   	_view.setSelectionMode(QAbstractItemView::SingleSelection);
>   	_view.verticalHeader()->setDefaultSectionSize(FONT_HEIGHT * 1.25);
> +	_view.setFont(QFontDatabase::systemFont(QFontDatabase::FixedFont));
> +	_view.horizontalHeader()->setFont(
> +		QFontDatabase::systemFont(QFontDatabase::GeneralFont));
>   
>   	 _proxyModel.setSource(&_model);
>   	_view.setModel(&_proxyModel);
