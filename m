Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DBFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 10:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiAMK0Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 05:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiAMK0P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 05:26:15 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4291DC06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 02:26:15 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c71so21287006edf.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 02:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bQKU4rk8oFF+TPMqGCOuNF/83Uuj1CMEIwhzOdJnr6I=;
        b=RWezs9IrJH488b26hk+y7HbKiu4kYPm+MFDVhpoWWreca9ucNYyjRGzNe9rxlEegif
         hbwdPIjH+yRGDsIUZYX1bCo74K9gdE+j8cXsVicYt6vwCtcS26gh84ZRIC1JP8gYMMFL
         q7QlPZx1xzYEFDwVpsW8DdE+X6aza4wCJ9JuoX29xgTOBHat4Q1tGwaFclAAHK5Ho8sQ
         FrSLGONsyp0llAKh53WzoSn4mxGsaurGhYDVPyGTd/W3H0RaI1pgptVfq8+FFaL/CLrV
         V3eQ6GnvNnkgMU5feZ5qbOoQ5WLer4+sv3enAWrSSchR3S6j9FwCNaA9Pkfr3bSP3vix
         Jl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bQKU4rk8oFF+TPMqGCOuNF/83Uuj1CMEIwhzOdJnr6I=;
        b=AjlC3FRFaU4s67hfq7z5yV//GXGuRisfbusqbUOs2clPJ2pAciWPFtCfcN0WdBB04U
         roOC7PHq29KRSPaNXofvk4QJw/xzQwlMCikDv75RBOPJXoPHAq28ZZFmcziA/13j/UfM
         3O8M2q8m9faa1Yqpi4xbi33r9nvk23eAiaybhIVKXNNueFax9j0Zz4tzkIjgCPzC9d5t
         TbbrhIf635VQO7dzHa8aXCdTG9s46J8LLHE6a969U6Sfk2NC46Z5V3b5oJ/dDuDktpad
         NutNNIcA4fvOUWiyQseYGy1fexJevlosSJPFNrUmryYvNIiwLA/a/Q3yu9UxJphc02Ci
         DF1w==
X-Gm-Message-State: AOAM533PN0EJfvodFksbeAra/D0f2ZzUOJHdgHT4fyFX9hkXG1QGWl3e
        5xgaKMDFjNf+TA5HsRNm2iw=
X-Google-Smtp-Source: ABdhPJwnkOvQDEctASojzlNRcQHWZ0LOGpkBtqxJqbmKvjE7iEoUigtBhCdBLL3ggB+IUe/CuMx2Xg==
X-Received: by 2002:a17:907:1687:: with SMTP id hc7mr2950004ejc.565.1642069573891;
        Thu, 13 Jan 2022 02:26:13 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id ga7sm720893ejc.50.2022.01.13.02.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 02:26:13 -0800 (PST)
Message-ID: <38d4a2a8-5110-2c19-be01-53a820726383@gmail.com>
Date:   Thu, 13 Jan 2022 12:26:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] libtracefs: New API for getting synthetic event
Content-Language: en-US
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220112163619.21762-1-y.karadz@gmail.com>
 <CAPpZLN7=q-DiOQWDmv5SdV7xyu9TCHHZNP_Cfq4Gdo2c2GMMPg@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <CAPpZLN7=q-DiOQWDmv5SdV7xyu9TCHHZNP_Cfq4Gdo2c2GMMPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.01.22 г. 7:01 ч., Tzvetomir Stoyanov wrote:
>> +struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
> The arguments of the other functions in this man page are not
> underlined, all should follow the same style. As in the other man
> pages of the library all arguments are underlined, this should be the
> default style.
> This could be addressed in a follow up patch - applying the same style
> of all tracefs man pages.
> 

So, do I have to change something on this particular line?

Thanks!
Yordan
