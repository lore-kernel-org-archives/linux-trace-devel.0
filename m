Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEC1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376324AbiDTIJj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376633AbiDTIJh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:09:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBD8B0C
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:06:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i27so1826980ejd.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kuXaX/F4zCzp7qIlff3VwR4GDZiNwqAFfue13M8FfRQ=;
        b=oBO8J73IekLT8c1uOukS4wkDMhZ7ssW4Rqwf0FIOzZmcKqNs3FGv01Xy/oEJ3+N//O
         gr2js/yEuisWA+68V8ilP6/IqcDTsZLoZaHVFlKDQV20VfJFW4EWbbhkfqw+cr9fCESA
         xSn8u4G/MyJZtIzZu5CZQbKVnk7/2BYp4TYMq9z5daLme3CXEck4yfp9t0pCt8qHlQVf
         dVrycIApWa/Sr4Bb+Ihhjdg4K0L/Egm50NXyX+gGTRAX+pXZZeOrvpHCXs8S+ETbvBSz
         WgCx36pBDi0RLXAB3JLTGDtU1kN1zL7byY6dzpD+nrW9K29gzCKtL/b1YI1PAusLLFEZ
         eWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kuXaX/F4zCzp7qIlff3VwR4GDZiNwqAFfue13M8FfRQ=;
        b=PU6FHJ7FEmtVVl0NYcQBXujWA9Sv+GdFPmd0g4EXt8bSBqAUHyoEOxiL3+zxQNVn/j
         BWOH3WOtmch+P21hBC3N0ogWYOLCpIrhMjkxlc15m7iz/2wVPk/WNTzOkHfkvQphu71d
         /c/kf8qyF2+bEaTSpuwDkd6GU9sHFU1EAW8vXdq6ztMdlKpyoD+8KRjTa4zMClaT9HJm
         y1EnyCGAa7LDat59QJRVKkILI3x5ET7+7SLnihIeCQ+mdYsCvZL/JmGbwH/Z9npPwFOm
         eSUqsGtl8H6DP13sH2Et8LEUC5gpXKLV6iFVVd+VxrLVj2W8AhlW1Wv8rhTBOD373Rzl
         MT7g==
X-Gm-Message-State: AOAM530U41ZVyOgvOj9xSL95PiZFwsv/ZtcfprS3MD5nSBJmYQ5WtQUw
        k7FJNYXGW9XDa63I5PFOyEHLxgryfaQ=
X-Google-Smtp-Source: ABdhPJw4fBwvfsooNTfaMiNBxVxfCiLRuSUdVQk3S01PwGjt/6p+802vNVvDj4cGKmw/nggaEmzmvg==
X-Received: by 2002:a17:907:3fa9:b0:6ef:f0e6:7285 with SMTP id hr41-20020a1709073fa900b006eff0e67285mr4549547ejc.350.1650442010149;
        Wed, 20 Apr 2022 01:06:50 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id i22-20020a1709063c5600b006e8a8a48baesm6536167ejg.99.2022.04.20.01.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 01:06:49 -0700 (PDT)
Message-ID: <146d751e-eb40-52f8-fbd1-3dc2627d03f9@gmail.com>
Date:   Wed, 20 Apr 2022 11:06:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Kernelshark v2 all-black plots area
Content-Language: en-US
To:     Solomon Tan <wjsota@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
 <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
 <Yl9WBztqKGD0PpmJ@ArchDesktop>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <Yl9WBztqKGD0PpmJ@ArchDesktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Solomon,

There are few things you can do.
The way KernelShark build finds the font file is by running the following command in a shell:

fc-list FreeSans |grep FreeSans.ttf | cut -d':' -f 1 -z

So run the same command in a terminal and try to figure out why it fails.
If it fails because the 'FreeSans.ttf' does not exist, you can manually provide a path to some other font file to be used.

cd kernel-shark/build
./cmake_clean.sh
cmake -DTT_FONT_FILE=/path/to/some/font/YourFont.ttf ..

Please let me know if this works.
Thanks!
Yordan


On 20.04.22 г. 3:38 ч., Solomon Tan wrote:
> On Tue, Feb 09, 2021 at 03:06:14PM +0200, Yordan Karadzhov (VMware) wrote:
> 
> Hi Yordan!
> 
> I have the same issue of an all-black plots area.
> 
>> Ciao Dario,
>>
>> There is a bug in one of the patches from the last patch-set I sent. This
>> bug was reported by Tzvetomir. My guess is that you are hitting the same
>> issue. If this is the case you must also have an error message saying
>> "Unable to find FreeSans font".
> 
> I have the same error message. I tried installing the `gnu-free-fonts`
> package on Arch, but it does not get rid of the error.
>>
>> You can manually do the fix suggested by Tzvetomir (see his reply to [PATCH
>> 15/24] kernel-shark: Update KsDualMarker and KsGLWidget) or just get a
>> corrected (rebased) version of the code from
>> https://github.com/yordan-karadzhov/kernel-shark-v2.beta
> 
> I tried installing from your github repo, but the same error still
> shows. I have all other dependencies installed. FreeSans is the only
> complaint from the cmake .. command. Is there another potential fix I
> could try?
> 
>>
>> Please let me know if this fixes your issue.
>> Thank you very much for testing and reporting!
>>
>> Best
>> Yordan
> 
> Thank you!
> Cheers,
> Solomon
