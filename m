Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAE2C3498B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF285246B8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sKMHb2CM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLMLoI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 06:44:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32862 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLMLoH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 06:44:07 -0500
Received: by mail-lj1-f195.google.com with SMTP id 21so2328821ljr.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 03:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SFgMUGfv5O6aUKxkjzg4z786Lcidv+V/S+pYGimRQWA=;
        b=sKMHb2CMhec5qRiBz44C/m1OokecHMxN2Z+8jDrbUTwn53A/qK3xg2lgVFRriP5JZH
         UBJ7rQvLam65WYTn/re9m5vo7mIJhuSx3o/0WTBtZbMxNF/4SqRDs9bjHFp24fbhy2E6
         BbH9NS6DHTJYgxXfGrwkEXpCh7BqoGWTSE+B8sQIkLmM6D7NCUNEmmVPPJgsuahkBZny
         QVR7M+Z2Gqx9c2JvUP/93bTbAT9sHupB6N7fWYQeHzNxXIFNf+hyqD9E1Ybu7bG4xj1d
         Z89wy6gzy/u3tonkB1afmC81VJ8ofWWepN1ZYbgH1+IPMI462tJdE5VLU1oFkxMD/VRk
         /+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SFgMUGfv5O6aUKxkjzg4z786Lcidv+V/S+pYGimRQWA=;
        b=WOdSSol3kCn+qemRIFCmYvbspuVTNMmf0Al2AE1XwI9pKxw4/0/eOmvQAqJ+t78hGv
         2GfSszbISAQSKxMWaGlba+ppla1TKEXYOvssfJxY6Bx0B5HPMmjJ8zQmYsHjpKkwvY7g
         e0ywRYCQYgOr/2RDCHCFrRV7z3nnMTVqXHqIAjbsK3H2wAn6Hp3Dgq/fRXmou2AeT6Zx
         5hNidYbZWbfrTw66GUPYERgKzIa3McP6uIonu/KZTMWFeXrW670O5xPT1sIoc//gPFDn
         x3doWDK2tYcS9v0Ap7yVCkz7iPDzUffMRhN14nOusLPPX3YlBKFahUh/rMhtr1CdAP8J
         9KIg==
X-Gm-Message-State: APjAAAVv9cM068sUud3JbVLuv4HxbuOlMURLCjCyV6ATB0VnasmYGH87
        Go/GYeaUulQeQcRaLYFv2iz7+7OK
X-Google-Smtp-Source: APXvYqynwKsmiG6cb1HS4G4wbUYwZnCQ5FUNs7XKKSB+C5EeDHO3cXoxQayLRgbdY4pjXOBKRQhVDg==
X-Received: by 2002:a2e:9bcc:: with SMTP id w12mr9314186ljj.105.1576237444405;
        Fri, 13 Dec 2019 03:44:04 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n14sm4412584lfe.5.2019.12.13.03.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 03:44:03 -0800 (PST)
Subject: Re: [PATCH] kernel-shark: Retrieve the home of root from
 "/etc/passwd"
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20191128114500.6289-1-y.karadz@gmail.com>
 <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
 <bf0dba9c-57de-a9f6-151c-cd40bbd1c312@gmail.com>
 <CAE0o1NsqJVjFgPyF09x-Hwog8cVGzr-m74PgM04CJg1i+oEjxw@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <9fac1a2e-cb68-453e-ffed-1997021ce5e8@gmail.com>
Date:   Fri, 13 Dec 2019 13:43:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAE0o1NsqJVjFgPyF09x-Hwog8cVGzr-m74PgM04CJg1i+oEjxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.12.19 г. 17:18 ч., Slavomir Kaslev wrote:
> On Thu, Dec 12, 2019 at 3:30 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
> [...]
> 
>> Thanks for pointing out this!
>> This simplifies the patch a lot. I am sending a new version.
> 
> I just saw the patch and I think I mislead you (sorry about that) by
> referring you to getpwent(3), since getpwuid(3) is a better match for
> this use-case and will make the patch even smaller.

Yes, getpwuid(3) is perfect. Thanks a lot!
Sending v3.

Y.
