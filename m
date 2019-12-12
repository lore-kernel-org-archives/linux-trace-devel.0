Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E413C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 13:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8F5214AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 13:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBoFZKrQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbfLLNbC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 08:31:02 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33723 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbfLLNbB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 08:31:01 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so1729136lfl.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 05:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aTNJWKURg/KaeWAe6MKEDgEgnhns61cqXqaQjY7o9RI=;
        b=dBoFZKrQQ6xfjCkU31UzkkXiKPysNzXsPWU68BJ7uvr9lWdgiJTGeCObiVGLQl5IBx
         RJO8RrLYEKOS9RmXixr+6hGvRh1VUMWXYQieaBM2CSpYg2DBh4v1IVB9+epi2gmqSuzZ
         7dvI0Hc8YgBZuM/ce6nPpvQXw8HsjnF/h2xc/Lo2/SrbTsUAzB983xRw5GyHqhEiAujN
         JxXpBKbNnb6cInWHxDjbtY6esEOIlV5auUkUVUkFpCnFQzOB2Si4YVNZW7Dk7mMxTsbo
         FHdkZmk/D9ylbWUt4r+6C1LfZXV+G+UQCZq9QGi2y/gjyZCkQabOT/AuehRNzvtoTGTk
         oq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aTNJWKURg/KaeWAe6MKEDgEgnhns61cqXqaQjY7o9RI=;
        b=dAIbi2BSa9bf3C/BGosBdg9MnVercq3x66rr3Wrzw7nzg4ZI1/9qbGIiriWWQtlUR7
         LYu5ZRdwM910DU2aGAQmt7Q34KveL6hTnuingz5kniXhWM7UOfA3gz+KFpTwZuisELtg
         yq4hOgsDiPhJF+Mpjp67YKEqXwlS1LTUC3cMVZQjbSbhNA8YgncWhm6AyOCDqq4H0xjK
         PLUkOJZ/RLEdOtNzGcrAhuAwOYsB7369vSooauwb821ju9gqSR7uosaWaxaeqP0o8bIn
         5riejLfQRNAmq8jHB4hebh1Sl5LgpHDIfLu8GxNeQ4rtr8rXii9OOwQRviMI1L3LGQXM
         9cag==
X-Gm-Message-State: APjAAAUsFheLVbZVIGgHvAc3EFssneVOUfjcxEOK/FER5QjgB/VpAMVV
        wjHogCBd0o7u09GszACK9z3czX5+
X-Google-Smtp-Source: APXvYqzj25LDHGwwYEZwKSgWwr0U+vUaqqX7V/LTGaKwqbtZeK1935hgAA0gXkrBWbqV4yfXKiRxgA==
X-Received: by 2002:a19:c382:: with SMTP id t124mr5622899lff.124.1576157459552;
        Thu, 12 Dec 2019 05:30:59 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n3sm2909542lfk.61.2019.12.12.05.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 05:30:58 -0800 (PST)
Subject: Re: [PATCH] kernel-shark: Retrieve the home of root from
 "/etc/passwd"
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20191128114500.6289-1-y.karadz@gmail.com>
 <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <bf0dba9c-57de-a9f6-151c-cd40bbd1c312@gmail.com>
Date:   Thu, 12 Dec 2019 15:30:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 28.11.19 г. 16:27 ч., Slavomir Kaslev wrote:
> On Thu, Nov 28, 2019 at 1:46 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
> [...]
>> +       auto lamRootHome = [] () {
>> +               QFile fPswd("/etc/passwd");
>> +               QString home("/root");
>> +               QStringList userInfo;
>> +
>> +               fPswd.open(QIODevice::ReadOnly);
>> +               if (!fPswd.isOpen())
>> +                       return home;
>> +
>> +               QTextStream s(&fPswd);
>> +               while (!s.atEnd()) {
>> +                       userInfo = s.readLine().split(':');
>> +
>> +                       /* Check the User Id. */
>> +                       if (userInfo[2].toInt() == 0) {
>> +                               home = userInfo[5];
>> +                               break;
>> +                       }
>> +               }
>> +
> 
> Another option is to use getpwent(3) [0] instead of parsing /etc/passwd by hand.
> 

Hi Slavi,

Thanks for pointing out this!
This simplifies the patch a lot. I am sending a new version.

cheers,
Yordan

> Cheers,
> 
> -- Slavi
> 
> [0] http://man7.org/linux/man-pages/man3/getpwent.3.html
> 
