Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20209C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 08:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D756100B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 08:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhD0I1z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbhD0I1y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 04:27:54 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC85FC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 01:27:09 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so2227239wmb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 01:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V6JjaMDbjGtnH45dGeQ5+yBUoDHfoXRWI+QB6O6AeeI=;
        b=oSdM602RfQAuJhdbsrR0tDUki6S5Nb8OFvJW8qJKsHVNnukTNsS61pS+PQNE+NNJsM
         EXF+PG6T5bSY7p8ThFdBejbS7VQmZI+NP3s7aXqtg9cOyPCclyPeyT52N4scquhECK1P
         cVLiUeltStBi8fcsZfnbO4ppuYQQ6GN1P58oau4gQ4nR4hV72WB8XZnt0NQiBDhrbv0X
         pO/tIbJkTXdjG5XZg9A4KT8Qqw0pCl1zUkY/2yn2saj2qRBHfKF4RZN3ikhk1eUhH/k+
         tFETOhVMbBhzOh6oxzjcU5R1SMhDrwHN2iU6V3+wdNhelaXA54di5aWUyBoseEzAfsJu
         t2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V6JjaMDbjGtnH45dGeQ5+yBUoDHfoXRWI+QB6O6AeeI=;
        b=HqVk8EnyxP9DyarKEAisEwzbYhfGTkHA6aRwSCR+4F+erFmtvOLomcB2sgZqms2o7q
         VdyQn7K7mkPLnBpFNWU7aCb67EBzD5wQDELPrWptegm5rKC91CA8SuoDs5n/5tXj9vVQ
         CDPI3HUp36ncDk1iy+KFJndFbN7auGpGNYPqdZqMHIZdA1l0YxCPxfHtjKkPVSaGzwpA
         e/ZcQb7ASXTjO59/vMirWLOh6xDYf3/b0vM6jfSnFJS4ZdlEsIrqdBpK24S4V8w6SPOE
         hpkvJ19nOGSj1m8l71wVd836unh49EB3kU7+4fpkt6VX2+OFhLMM1kjaZ1JHpyuDICXU
         b6Fg==
X-Gm-Message-State: AOAM532bY4zvAYVzudVHB7C6C5vqDQvYuoAcBeFmIDi7Rmb9/1XpZZum
        4j2NGFszjhDFcHFiU3wwNpzIr4SZwYg=
X-Google-Smtp-Source: ABdhPJxCWZEIrA53UmiSg6jbmDqjssm9sLXqHHLtsM221jWItC3G29HPZ4WBQdaAn/+CauOornMWgA==
X-Received: by 2002:a1c:a914:: with SMTP id s20mr3077372wme.106.1619512028384;
        Tue, 27 Apr 2021 01:27:08 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y21sm1750243wmc.46.2021.04.27.01.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:27:07 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: Add support for non-qemu VMs
To:     Joel Fernandes <joelaf@google.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210426103528.634418-1-tz.stoyanov@gmail.com>
 <CAJWu+opRp9tN7iHGh84kgYVNE57U8rmA6rNtvQ2PKJBzdo-Baw@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <732644be-b09c-47d4-c776-e91d4f4ceaf5@gmail.com>
Date:   Tue, 27 Apr 2021 11:27:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAJWu+opRp9tN7iHGh84kgYVNE57U8rmA6rNtvQ2PKJBzdo-Baw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,

On 26.04.21 г. 21:44, Joel Fernandes wrote:
> In the below drive link , I saved the .dat files and also share the
> KernelShark screenshot which still asks me for an offset in a pop up
> window.

This pop up dialog that asks for the offset is a legacy from the time 
when we have been been doing the calculation of the offset by hand. It 
still can be useful in some specific cases, but the user can do the same 
from the "Tools" menu. It may be better if we disable the automatic 
pop-up when a data file is appended. What do you think?

Thanks!
Yordan

