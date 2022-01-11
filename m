Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B0BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 08:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348928AbiAKIcU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 03:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348925AbiAKIcU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 03:32:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E00C06173F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:32:19 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id k15so63876625edk.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=5pibUGbWOxJfRQLLVaeNguNejtF9t1oFn8rZf8M8JqE=;
        b=BwoS+TetMK5MOmbAzUnSO3QfKTCf2J07SXYVIKVvpij9THz6z8NU/I2tFtOG8mmmhG
         ui45gdO22UrwktWVjTOYxP50DobdwMzUYjj+8a1ufLTWHXIpL3ZfbfGH839ftSHRQicn
         vtI8DUZJs6NYlw1Emr45MMWri/+3kX/RW7RHI/alDq9l+W8y3WcMr2OidTAX/8JaD53g
         nqG3+3FaCxeLMsdBNbSZmfkJTXcyXNCBAHinqGwVM8/BKKqsjC90R/YL1lcn3eS6hI1n
         d9JZ2vRviJ+hWBteO4CxYXzQ5TkIIe6LVJ2oQe74g16RyJJX80LlngVxicO3KbfYrLMN
         ndUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5pibUGbWOxJfRQLLVaeNguNejtF9t1oFn8rZf8M8JqE=;
        b=Mjjn7edBm0iH77WTIZ6aJgC5f+FxDy4EaApNBEJBHGKyupmNqXIPZZWcKf99R78kaH
         GCQG8EiBKZ/mXZZ8Hux8b0bmcTGvRel0bCcZrVtHsq98So1LEBolCxlE4p9qRvw51SwI
         nY1KoSYPmgcz/zHc5x62NabNRNIpis6HlzRr/bIej0y5kRPsbsegQ3mE9Vza+ypnAVX0
         p+roDcs9KZltkI1ksCLE8hpPakafTy4mKA5O/71KP9BFYZCgrnur85xAEHuZMV7qN7xO
         UcAXJWmcyVXtDjHIohIjfgZXf11ye71J5HT9XFSywfRj5/zcm24urrreXoeLrwPzlDDr
         M7RQ==
X-Gm-Message-State: AOAM533osQv2CpKApECf8+nlfUfE6nL03ZFhfCd7IcNr7mYpaJ48X1je
        O1IGKYEXExvBMuCuNRmIUy1CUC31q4s=
X-Google-Smtp-Source: ABdhPJyQADGdn+7h1Mj/pvwrdbArRpnmqS9MzG+b6lqiRpN7FkGdUuDK1s7le2e9w3jUCp0/LiNl+A==
X-Received: by 2002:a50:ee06:: with SMTP id g6mr3294322eds.162.1641889938110;
        Tue, 11 Jan 2022 00:32:18 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id 18sm3322496ejw.187.2022.01.11.00.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 00:32:17 -0800 (PST)
Message-ID: <1c1072b2-14e6-2735-e065-732cc69a9938@gmail.com>
Date:   Tue, 11 Jan 2022 10:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH V4 2/3] kernel-shark: Move common APIs and definitions out
 to avoid duplication
Content-Language: en-US
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20220110042518.9376-1-hongzhan.chen@intel.com>
 <20220110042518.9376-2-hongzhan.chen@intel.com>
 <93580097-5496-5373-484b-322fc407c61a@gmail.com>
 <MN2PR11MB42853BA4A6B28E23BBADF6DEF2519@MN2PR11MB4285.namprd11.prod.outlook.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <MN2PR11MB42853BA4A6B28E23BBADF6DEF2519@MN2PR11MB4285.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.01.22 г. 10:03 ч., Chen, Hongzhan wrote:
> I will modify it .Sorry for the inconvenience.

No worries.
cheers,
Y.
