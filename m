Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B24CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 16:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiCNQG6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 12:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiCNQG4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 12:06:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFA040E51
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 09:05:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p15so35092272ejc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 09:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4yM17wwiyUGH6My7tSGI7a1g4dFIdl9BSAS7NoYP7vA=;
        b=oKR9VwBPdRhPEqi0BKjCWBeiaE9Q+HD8fYzGN4V73UDMrpTHh6sprLUh0FA6uWuWzT
         aTtcXFbsgnoFGKI2go5v0YFQ3ieZCfDPqywAUzayYBcJJ/DnGe9hypGJ1LKHBodL7VKO
         O+8ZSziEJhcbkvg8AC+8Vbm/ZOca/7ceU6+ze2XYAofZ1B2cYSwdQ8cKsAvOfnP1oz1i
         iM+KQ/BTa5tx2AD4P644xI3SbXkA2j1+/wFwDOPTNOABITyMAPydy2t7YDuTxZrupFH/
         UvlfeYpKNHAD9HKFykRxNnNRMzhpou3PNk14IVsLK0qgoX4uQ9Ub9qShP86mRt4ngvFM
         MCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4yM17wwiyUGH6My7tSGI7a1g4dFIdl9BSAS7NoYP7vA=;
        b=tprne6iYZGtTtAER3EXdM/DxRrnKZfXkQFlKT45UOg499gF4h8z05Ieag73l89Cpvo
         VU9vOCqN2lMbkrKm7LdSVoYji5/S0WtzZ4XxH8zmZGHu7C03rlVzVo1s0hZu5QxNumWz
         c8ewHWQVUJu9viX1RhGA0Yx5WpKHjU2ywCaNTLCdVM47AwacaJHwFCM89mCAS4eFXrrT
         UdE8kwHFOLNEIlH8DTsajIrzTS/MsgM/0X7XFx+lbcWej79alzRt230zIRQo3QZN5U04
         XD0SyCplJ3kPamAFiWN890Sssu88Za3hsqDGcvap+0V1G+pLJpHcU5Cv+bXtgzHgttPP
         sGmg==
X-Gm-Message-State: AOAM531LBPT9vjifkv2EU5weOGgwexpn1/2fIHE5YiG6eJ7yqW9/Q1fV
        WVe+eQQE2Cm/wDDjD/1PYavUY2YQEqA=
X-Google-Smtp-Source: ABdhPJz3HWOhcmHnBE4z4I18hJGIbIhmDXmTqdisyH0TRQoOi2zoMYHWzYd7UsukEXkKEr+4OB4s8g==
X-Received: by 2002:a17:907:7ea7:b0:6db:b3c7:95d6 with SMTP id qb39-20020a1709077ea700b006dbb3c795d6mr10970681ejc.480.1647273945664;
        Mon, 14 Mar 2022 09:05:45 -0700 (PDT)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id q15-20020a056402518f00b00416a3194924sm7847522edd.75.2022.03.14.09.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:05:45 -0700 (PDT)
Message-ID: <e3cf4859-f9e2-6919-1851-a0f8bc343504@gmail.com>
Date:   Mon, 14 Mar 2022 18:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/2] trace-cmd library: Fix sparse cpu_data
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220312234032.127108-1-rostedt@goodmis.org>
 <7aeb8865-3f66-3938-14a6-48b3147455ec@gmail.com>
 <20220314120111.5e981ed4@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220314120111.5e981ed4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.03.22 г. 18:01 ч., Steven Rostedt wrote:
> On Mon, 14 Mar 2022 16:59:13 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> Is this fixing the issue with kernelshark crashing when trying to open the new format?
> 
> Yes, it was.

And are all this CPUs (active or idle) being properly displayed by KS?
Y.

> 
> -- Steve
