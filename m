Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B035BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Mar 2022 11:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiCVLeH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiCVLeG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 07:34:06 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B9082D26
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Mar 2022 04:32:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o7-20020a05600c4fc700b0038c87edc21eso1495341wmq.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Mar 2022 04:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=cDMeAwZIKvOQnh2J6RSRlQRaOhC9w6fYgYKbLbVDuOI=;
        b=L6xBaylTwePXggYvDgGn5UdwyRQ64jkRSDjEtP8N+S3sfrtZHW3r6d08plYUMb751v
         86XHHsGYQFAnw/GYeElk1dcvpNmC99NY43u0NZiIo15inAK+NCKtlb4BRgDSxSUZu6Pq
         4H7bsWxrfO5oWMTdvV+n1uWCtq+owBM2xcE5C832PhX/yr0+SRO4NeTnGD2tJTPMHzJ/
         P5q+O7HMl/UqEpJR8DtKhfa8EMf2dlEqkrJUUQ5o/ehsOhn/FQZqnJYMFju5LX06DVPD
         2pK8w1/SiHrv9Sz7QyNnEssCIiHaxXK1gnk2eOp1CYnOxxPKAKihfE7aCo8jmIgG1jTT
         +nDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cDMeAwZIKvOQnh2J6RSRlQRaOhC9w6fYgYKbLbVDuOI=;
        b=NADqyeYlWFkDdADuBxdiQLB7uCSZ7gQNBru16O2PgPROd5wBIvtN5/Ld0vOtxcohVJ
         sYaSmXTnfGb/DVwSC/dzrtjWGz6qRThGmlYfTuDlqTAufNBHhrmzvp8AgYQWd3r6UC6D
         j+2DpdnJMh5QnaNUCpciKwXYs8RThDYyQT8WIPdUTa4VyAwR3Vf4TJA7lQ6zUxf9GO58
         LFRSuvj8HIw1Y6OMOcPAf2OQEPhLnzEmEhpipTYxCnZA5wInL1ocDPsVb5ohd4l8N6fr
         zGy/A713OrrmFR4UIN4YM06DFyDa0hU2tZNaWKAAehr/RwG1YTH19cq9q638YdOMxwwB
         ZmgQ==
X-Gm-Message-State: AOAM531GWzRTak1BTm9sPQasNJvFIDSrlPI32OLLA4LLTaJLdxqtJ530
        APiuAtFUnrecODLDHutrHxdYk+LESJs=
X-Google-Smtp-Source: ABdhPJzPhbh9yr5kqnixKvcAj0QPJUQRoxemcqf7velEdXqMX9zxC3fsrseUmUFqG8mHbcEco2K7vA==
X-Received: by 2002:a05:6000:ca:b0:203:dbf3:8f8a with SMTP id q10-20020a05600000ca00b00203dbf38f8amr21984573wrx.10.1647948757945;
        Tue, 22 Mar 2022 04:32:37 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id m9-20020a05600c4f4900b00389e8184edcsm1693041wmq.35.2022.03.22.04.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 04:32:37 -0700 (PDT)
Message-ID: <113dd55a-1324-c3a7-7663-2e206e069a38@gmail.com>
Date:   Tue, 22 Mar 2022 13:32:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] kernelshark: Set QApplication::desktopFileName
Content-Language: en-US
To:     Nicolas Fella <nicolas.fella@gmx.de>,
        linux-trace-devel@vger.kernel.org
References: <20220321225330.825082-1-nicolas.fella@gmx.de>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220321225330.825082-1-nicolas.fella@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.03.22 г. 0:53 ч., Nicolas Fella wrote:
> This is needed for properly associating the window with the desktop file.
> 
> This is needed for e.g. showing the correct icon in desktop environments.
> 
> Signed-off-by: Nicolas Fella <nicolas.fella@gmx.de>
> ---
>   src/kernelshark.cpp | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
> index 92bc1f1..c373f54 100644
> --- a/src/kernelshark.cpp
> +++ b/src/kernelshark.cpp
> @@ -56,6 +56,7 @@ int main(int argc, char **argv)
>   	int c;
> 
>   	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
> +	QApplication::setDesktopFileName("kernelshark");

Hi Nicolas,

Looking into the Qt documentation, it seems to me that the argument must be the desktop file name without the full path. 
And the name of the file is 'kernelshark.desktop'.

Thanks!
Yordan

>   	QApplication a(argc, argv);
> 
>   	KsMainWindow ks;
> --
> 2.35.1
> 
