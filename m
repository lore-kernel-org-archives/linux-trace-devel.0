Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970A5C282DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6578D20880
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecvbpAcq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfDOLRA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:17:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46224 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfDOLRA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 07:17:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id t17so21351814wrw.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 04:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=awhpii9IVZpTW7x0ij3Ue6s0TYvFwfvm/3xFQekSXaI=;
        b=ecvbpAcqrl/jejz/tFrA5/tsp8meCVzHAuNvKQyyQ3YkZBKVk424WyYTKb7FU2klAD
         tzCCmICOrKpEwbMsnWGSYCA47Xz44WzCNS2CKsgpc4jhvu9O5fNXa61iBzvZbL/WggnZ
         CjMW5AGjDi6eVXCmvJVXHSGjYJoxW1p4yauuYiS6sF4cwa7npnsm5lsUKg1raUppeKbj
         QRlTIddYk+tjgLti/UrjyS8XodrhI87jNMYvtKfsWM9RSaVTeyzBFYscK7Jw6rZZdVM3
         61LYwVdFm4vAiYy8MFL8va04VQNF5csfnK21K4JaabgywCRSM63eInpP1wWxSpwatIMW
         wPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=awhpii9IVZpTW7x0ij3Ue6s0TYvFwfvm/3xFQekSXaI=;
        b=kyTi9V1NJj2ymuH4iKegPHJ+bx4T6XViCW6bflop2ZtfqbiGPCnphaOnjPhkTqcS4Q
         40kf5NebnGM9IDv5KI2QqRrG/BwgtRPgQKDnAwGX5Yo6JRP8rkQXxBWLWAyrX8QAAV8Y
         4gDrePUf/t11PQ0T9DZrteU8JUFZqN0jUTbfjdOAyHyNDFXPDDjKecFQvFppXPeViJtC
         6yy0zzPjK/d97SH5/dDrpQXmmPw570eE1/puiTI/WUpLI/OUdFrN9lMgKmJN6yd1+YxH
         Pm8Bew0Q4OBQ20QdrRrnxXyGvVCJygdmgj6ogAGNmKf44q7ALYnS8Ru72N16nx/xlsO8
         NtOg==
X-Gm-Message-State: APjAAAUkp9aw1ZYhNGP5a2w6IHHskeninPo+j5W/X0q4iOpQWZhdRwst
        cCU5W4Wl4fo1Q26uhq0IJoGmM9Yh
X-Google-Smtp-Source: APXvYqzqhm2+PkjJwX50tcPlNMJ3kicT8l5XmFu0crYDxb9R/GGChiUXWMvtqhozKz868FjU5k5J8g==
X-Received: by 2002:adf:e74f:: with SMTP id c15mr45255799wrn.23.1555327018300;
        Mon, 15 Apr 2019 04:16:58 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 7sm169745170wrc.81.2019.04.15.04.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 04:16:57 -0700 (PDT)
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
To:     Slavomir Kaslev <kaslevs@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
 <20190408111308.301f30c1@gandalf.local.home>
 <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
 <20190409092349.3e7cb6e3@gandalf.local.home>
 <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
 <20190409111100.28297adb@gandalf.local.home>
 <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <30661ef4-5fc5-d362-3df3-09fb1cc54482@gmail.com>
Date:   Mon, 15 Apr 2019 14:16:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.04.19 г. 18:44 ч., Slavomir Kaslev wrote:
> KS_DIR is used runtime to load plugins, as default path for file open
> dialogs (which doesn't make much sense imo) and at compile time to
> construct relative paths in the source directory. It is currently
> defined simply as
> 
> set(KS_DIR ${CMAKE_SOURCE_DIR})
> 
> I think there needs to be a separate constant for plugins path that
> can be set at build time and in distro build can point to
> /usr/share/kernelshark/plugins or somewhere where we want shared
> plugins to live. 

Yes. No doubt that this must be separated.

> The compile time uses of KS_DIR are fine though
> ${CMAKE_SOURCE_DIR} is clearer for the reader. The default directory
> for file open dialogs can be the current directory or the last opened
> path rather than the kernelshark source directory.
> 
> What do you think?

I still think that if you build KernelShark from source, the most 
natural  default path for the open-file dialogs is the 
trace-cmd/kernel-shark directory. However if this directory doesn't 
exist the dialogs can start at ${HOME} (the one of the user running the 
app).


I still think that if you build KernelShark from source, the most 
natural  default path for the open-file dialogs is the 
trace-cmd/kernel-shark directory. However if this directory doesn't 
exist {distro installation} the dialogs can start at ${HOME} (the one of 
the user running the app).

What do you think?
Thanks!
Yordan
