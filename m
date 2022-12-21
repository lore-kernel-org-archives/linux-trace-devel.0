Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B525C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 19:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiLUT1s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 14:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbiLUT1r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 14:27:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0005726483
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 11:27:45 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id m18so39163974eji.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 11:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TXDZGnX4Kep9pKOc97GcieXSwAxCPpHhX1kBryl48pE=;
        b=h9yDSgycTdMNoTp18MlUMTyMyaJTQI66Swk2WczxGqMme4CMk+g4AGoJDGbpto9mEj
         w1xACTVXfjHlZkCuT3uMAVNYQKBLMWGI5yBhKWv9Tds9P34gKYyfvASTncI/BRlqDiZ4
         A0tUrIsDVw+AGID9tMBIiUKsQoHUS5QdsCAEvuILwAVZVFCbOwKDgnbegbgwWX4WGZ8e
         z0rSfxsiW91WMiitoYP6r2KuBFzE6wiPwkSTO0WG+6rB94QCB9hXV/m1Jrkn+GNM3euT
         dWeII+aablBTSPgld8H190kfm8hcYUquQZI+3hrcLFkKU31xePiCAO8lRMlOda+3VGMp
         9TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXDZGnX4Kep9pKOc97GcieXSwAxCPpHhX1kBryl48pE=;
        b=coZkRmpk+Y+ncezrXz9HxG3iJl3aYl1oQ/6Nd4ZI/T9/ig5BrTciuJKJm7wx8CxvgO
         GAqguanecGuxN2Two0B0hGZnDt3pnnoybCzMmv0GznyCrn9i1s9kSdPiwy82VwT6wu6z
         rwuB6yphGyB2a2oXS2WFBZzRh8C54npN+iBMkf2OrVwDyCGbDerqSfxg4Qk3rmT/1pWB
         P0kr05iLhmc85T5aAHf6QLVTH1gGFcUjzh65iBn+W6R9Anh3ZPmD9hYrfmc9Yn2B6UCj
         kRW9Doj0SARM3BfYJuI+Y8f8RvJPXS+TenZlE357HCZITyg2o4vfLWhFzfFkL7k5WjvT
         A3WA==
X-Gm-Message-State: AFqh2kqAUc9HPsBaxt1eui1e524Ddpl2+szO9rSh2oLWtLDXIz58pAV/
        Tdpd9KWQe73JJAhkosdxpvPFcp4yNoU=
X-Google-Smtp-Source: AMrXdXsxLnMAU/gSAWUekyJutmsxxVqRiD2rPMya4xIiplWkc73nvBbEUfCY6cGHmz7nTgc2RgoxeA==
X-Received: by 2002:a17:906:688f:b0:7ae:31a0:571c with SMTP id n15-20020a170906688f00b007ae31a0571cmr2468231ejr.57.1671650864527;
        Wed, 21 Dec 2022 11:27:44 -0800 (PST)
Received: from [192.168.0.101] (78-154-14-113.ip.btc-net.bg. [78.154.14.113])
        by smtp.gmail.com with ESMTPSA id ku13-20020a170907788d00b00837ac146a53sm2420502ejc.23.2022.12.21.11.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 11:27:44 -0800 (PST)
Message-ID: <67cc28da-88b4-9a83-4d42-b0af051cd589@gmail.com>
Date:   Wed, 21 Dec 2022 21:27:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] kernel-shark: Show multi-line events in quick view
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20221214154643.43a4e137@gandalf.local.home>
 <4470bb69-1558-5775-67ff-9b6b0779f573@gmail.com>
 <20221221113549.549f58b4@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20221221113549.549f58b4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12/21/22 18:35, Steven Rostedt wrote:
> Also, for another feature request. Is it possible to implement a copy of
> the text in the list view? I would like to select text and copy it so that
> I can paste it into other windows.

Should be possible. I will have a look.
Cheers,
Y.
