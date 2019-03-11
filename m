Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85C9C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C76E20643
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/CyXpE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfCKRo5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:44:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42502 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfCKRo5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 13:44:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id o9so6119421wrv.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GrcFe6IxoRCcjraOgpjoM8BF4VUbQeTM0MYrgLTaEms=;
        b=k/CyXpE5bIf9p4P7EUsR7SIK+Rr9Q7LAIntoXBE3LDIYQKZ6OlaH5JBYDK/Y+xt5uH
         HjiiKt3FJwFWLXj1mAMfpWInBTNZvZHAfkhSZ0yUpln+uJpXIHeOMF3zlLAUIAjPq4t7
         dcz+yFeFFPltCYIlUWbfFLM9AGuT+VjCZLg9jVXohx/Q/N4HE9L8MygPG5Kkh8kEzznW
         jJmCJduL4ZKYXpfiC2dCbUTMUbI9xstJGSNE5poK8e2Eq+41NOfGKFdP3S8vuKJZE/Kq
         gaoMFarZtaIX2MIFUi1EwZeYBumS917Lem2LvxRBNYvd9MizAH8wgMaGxy6Pv4vVJwp6
         8Rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GrcFe6IxoRCcjraOgpjoM8BF4VUbQeTM0MYrgLTaEms=;
        b=DMI4DnFVzOGAQsd4JAgg9NCEck9Sr57cxkDySU8U/l4vCd58lzYBjsuU1Kg30na+UQ
         yvb2MujSvpI4OMMLK76SEWdNj2eeg5QkFUUZ3d7A8ksvWHTIhsDF6RtSkEb7tOprRT8+
         b7srJeSVSK8gMDfWpoMXGJi0Zr3lhcxpA9Z37PfOVS3Y/iaX7V2gk8xJkpdDqkhjyp5W
         ixxl1Z++xQ0uxYfEQS1BrrmHo7q/0j6g1AjMC+b9eGY5RFN+CsFjEVRWCCPYm92OrMhB
         5BEosmSLhvXQGslStLbJR/U5iRxIn+3oRSpzJXZWu/z3E/rcfBneqAWj2hKRCw+E/ckq
         3l1g==
X-Gm-Message-State: APjAAAUUHDG62nQEKfHnHTCfW/zjVGKZJjhLkpObRG+wOjmq/qx0FZcX
        dexWybWkdETV7EKu5EU1rnmSinKTkVk=
X-Google-Smtp-Source: APXvYqyxKJaR4PwX7qYmfO43qp0xkKWwnxoYorSyicnnqIsZNcRVpgA2RxLbLF4ibzfaRqDMkBfP/g==
X-Received: by 2002:adf:de8d:: with SMTP id w13mr2421492wrl.249.1552326295186;
        Mon, 11 Mar 2019 10:44:55 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm11574662wmh.12.2019.03.11.10.44.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 10:44:54 -0700 (PDT)
Subject: Re: [PATCH 3/3] kernel-shark: Set the location of .kshark directory
 via env. variable
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
 <20190308171512.15372-4-ykaradzhov@vmware.com>
 <CAE0o1NsC2AFgO53EumUC+kB8-0Ed8+k5dmrEsGfiCUhf5AAVPA@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1dbce93d-de22-1b67-4637-bc1b3ff16d0e@gmail.com>
Date:   Mon, 11 Mar 2019 19:44:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAE0o1NsC2AFgO53EumUC+kB8-0Ed8+k5dmrEsGfiCUhf5AAVPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.03.19 г. 14:16 ч., Slavomir Kaslev wrote:
>> +}
>> +
>> +void KsMainWindow::_restorSession()
> Nit: typo _restorSession()  -> _restoreSession()
> 
>> +{
>> +       loadSession(_getLastSessionFile());
>>          _graph.updateGeom();
>>   }

Very well spotted, thanks a lot!
I will fix this.
Y.
