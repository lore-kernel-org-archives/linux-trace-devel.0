Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451BAC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E2C64E54
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhBHKjj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 05:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhBHKhW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 05:37:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14485C061788
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 02:36:41 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b3so16436021wrj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 02:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aR0t0aWDwVqgw8brkEE5M41HPkTeRJ0aegQpdBX9SpQ=;
        b=Ujh5inbJ9Y6mrUE1rw7Crbg4SAyqkMwHJOy8Gs2GVHt5pfH/QMJRf1ogHYPXJVxWcS
         MMFx92BptZfthBlUx1jKaF+EXc+C/aONz2epGrm87RfOW5tdbe+8DjYYPN9TdweVgsK3
         V+1O3qpvOp1cyRW2/IrTfuAq0U0TxNyBuSUWKnTfC7pFnLo7Cdl4eS941ycKCc0dA8kq
         SdNWaqKOpttMbehKCuDWinGihdxIyrp2+0TVWF4x3d/+Tir4R7H20eJ0BPN967sHPw0P
         NXB7Q1alvlEVNSH+CZZUprZ6tRMGSTKhHV/1o2t5v/kTDPrbH4VnvOE/YmVMsY2T/Ytu
         vT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aR0t0aWDwVqgw8brkEE5M41HPkTeRJ0aegQpdBX9SpQ=;
        b=m8yJFbj1pdDDDRKI6q2fToelaTcjodJiyz6uV1//QoJo1j5P1TEF+24ipmDUYAs/KQ
         kCp/AFSEVdMT5iixZpCB+pe2QwMGZDABWbsSx77unf3LSWNx2R/oalEsbdp+z5GklhvH
         vOi5pTURSUvgSptyWJwcI8xfzmkHFTfQNTEoGZbzPXkenxF0HqkRUZRUCoj6yI09vo4o
         bHuCCuQpxEiBs1HHXYV8zhqHRXyEciVQeLQhPlpj14N/IFngKueHZXBlj8xmG8+Vl173
         tU5RnikN2laza7RhoCkdBB56CfY476i8SAP6KHBM/wwazY79TIZXi1P509MA8CX2FTAe
         4wpw==
X-Gm-Message-State: AOAM530lCWTAXXZ42S1kGlbtIvN+kj81gxCJsRT3j4AMbz5pqtEL6y25
        0XdXNIQr8rgfstJUlhsj38OiKEvlIMs=
X-Google-Smtp-Source: ABdhPJxCOvDAI4jTcOjZaZ6hu6zqolRlozzIWW4Con0Y1gWSUkWzV6WaQYIUaDImCwKyx9YvJZ/k+g==
X-Received: by 2002:adf:fd52:: with SMTP id h18mr19395984wrs.295.1612780599724;
        Mon, 08 Feb 2021 02:36:39 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id v6sm28223545wrx.32.2021.02.08.02.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 02:36:39 -0800 (PST)
Subject: Re: [PATCH 15/24] kernel-shark: Update KsDualMarker and KsGLWidget
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210201172358.175407-1-y.karadz@gmail.com>
 <20210201172358.175407-16-y.karadz@gmail.com>
 <CAPpZLN70NLutFfwe8ftLk9T8bMAG-OsUaYuOXJA50n8eVC9kzQ@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <db7e3029-6a35-74be-3186-45e5db03d2a4@gmail.com>
Date:   Mon, 8 Feb 2021 12:36:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPpZLN70NLutFfwe8ftLk9T8bMAG-OsUaYuOXJA50n8eVC9kzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 5.02.21 г. 12:49 ч., Tzvetomir Stoyanov wrote:
>>   /** Reimplemented function used to set up all required OpenGL resources. */
>>   void KsGLWidget::initializeGL()
>>   {
>> +       const char *family = KS_FONT, *name = "aaa";//KS_FONT;
> The name of the font should not be hardcoded.
> 

Well spotted. Thanks a lot!
I will send corrected version.

Best,
Yordan

