Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F197C433ED
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Apr 2021 01:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1352610C7
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Apr 2021 01:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhDKBNd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 21:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKBNc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 21:13:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8ADC06138B
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Apr 2021 18:13:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y16so6797780pfc.5
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Apr 2021 18:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=+/hAhod/f7pKatiGayZEWFYebRLkoBSBQqRnjIFagAI=;
        b=XvyDpQvMr9BPUw92FmaxOfJSix5Va6YWm4R5ZzXnQDEhmLsSAAU2h1yIJ/c+881fB0
         An8KFO3uVF2te7wlN1ulZvjspfcNeLoWJu6PRPdugFw1lwn3+od7Xt280Lb4Z6jLnUlX
         sYQNYXL+EQSqS6pbWB2LmhfD18h2GF9yBu5WUvkhOQX3o4cvlDL5wHk/hLhzmHjhUEMB
         7Nz6F63xV9YmGl+d7abiS/3TiCTShOvFzRiz1tTYbpUSlNNnC1jYe4dJx7w1sDWjR7MG
         eUsZ3VxdKNef86prssrjoQOvAG9Y3UFybMM10zf8AgDurfXsk27w5D0Bdbfym+xt3sZq
         beLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=+/hAhod/f7pKatiGayZEWFYebRLkoBSBQqRnjIFagAI=;
        b=H3px4vsIcCYTdwURv/bK0durujbTLgtiuoQhRy1rPQEIpbMpl6C1JHmwoetRfTrXOB
         Y4G5GJD+kjuRNHjGp5bLbIIXWQKpytFBRwkOpShz0bG4a+g6EQ4Yq0VYuH9TNDFv+jHa
         b++krLHO8aIf48A0lTIQUQDML3UMyvh9kTm9x1L8KZ3aq9OAqjVU+WiTPRql+VCpwYeQ
         BdV+8XwjhZOKKIWI16XpthVoTCT49m9AjDn3NKVbXuCnpKoleL8UEFocHz+dP0FbZBVP
         JZS1PYgWhIe/t7GFka/ZOWoJVGzoVw/HBgfIknH0mbE1podS9dT90NADMPiGMm/wpVFY
         xDsQ==
X-Gm-Message-State: AOAM532wTYTcZkRxzdQWPEJI5z+akv3Say8jNMrwoNFlMJp1GyG6M0JY
        Om9Yt0KhB6GbTaFjCiAVbDz8r3eaziASKg==
X-Google-Smtp-Source: ABdhPJyZuvnY6/lXhrq+s0e8YxK0GuWr5ackbQZtd1EgPkqQWUvrYC3xWVDP3w71ENisapO6Hh5plw==
X-Received: by 2002:a65:4c0c:: with SMTP id u12mr19660995pgq.122.1618103596898;
        Sat, 10 Apr 2021 18:13:16 -0700 (PDT)
Received: from [192.168.0.115] ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id c21sm6768660pgl.71.2021.04.10.18.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 18:13:16 -0700 (PDT)
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Bug in Test code
Message-ID: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
Date:   Mon, 12 Apr 2021 06:43:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi,

Test: tracing options ...FAILED
     1. tracefs-utest.c:746  - check_options_mask_empty(all)
     2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
   Test: custom system directory ...FAILED
     1. tracefs-utest.c:746  - check_options_mask_empty(all)
     2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
   Test: ftrace marker ...trace-utest: ../nptl/pthread_mutex_lock.c:81: 
__pthread_mutex_lock: Assertion `mutex->__data.__owner == 0' failed.
Aborted (core dumped)


Above tests are failing for me, what about you guys?

Do i have to give any command line options when running the test ?

I ran test like below

-----------------------

#./trace-utest

-----------------------

--sameer.

