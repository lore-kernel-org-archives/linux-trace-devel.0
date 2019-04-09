Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC39C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0CE20857
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8d96TC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfDIMYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:24:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35285 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfDIMYA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:24:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so3124284wmd.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Apr 2019 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yzGYwNzETEwgqd70FsT4MP3w7H98WDJHq6Bf1WktoRo=;
        b=h8d96TC5HsfIH+48arpei0GZvtQnCHxYoER/zwOoHQsPPZVFRNm9MoTnBqYB1N64WQ
         6oquTlfLDNzUUyevwSLfbbxxmPNqn3W0AgS2RiWrV3L8Dafl5pggoWuDDPegmXu5UAoq
         BuiEdLXTzTOgefz/TjfjUGfQ7L917w3SLjblXP9bra+qL+bG4WAoK7/zNm2085eiByf2
         HR4Mrb3FOWcErFV2l+f/ug//Mx3KRU8dsbhitOKJD2DjZHNQJIF6J6oOzsVPDIllr+rA
         GP8TsNbiZXVtaY5JQg6ybDTEStMBQTFpwLBysa3hq+EjQ7YBZJV0jWeFy40xMjApXKtn
         BBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yzGYwNzETEwgqd70FsT4MP3w7H98WDJHq6Bf1WktoRo=;
        b=tzHT9EfPAaiJrmc6Cu7W1en02MSOP70CLrfTOKDtqyjAud8zl0LLgLJqx0uAcWXisX
         dqNCaKjj4vbTV/9ALDbAFzlGTy/05mzaBpYeBDh867MZfIkie7C+daFMejbT7Xwp9S41
         V1VQG7CqjaWHCHb1QkYh/wN8Rlo3CL+pue92ga3Dw2wZyrxTjtq/ziJEPAxx+wMSb+4K
         3iJ14lhRIpmOQVSp5DDNN5SoOjwHPoeMIM8NJqJqaejZaTfmUg27XyTQSXYzskDy9d0x
         2Z0fOq4pT+lL9BDs07UFfknTHE0AC0az9Hbz3DElXBiOzl0cPVPbHA0JvBNWET2cl8PI
         +ekA==
X-Gm-Message-State: APjAAAWey1BDIfTJfVMAHn1iyONvnbTmdw4Y3eB9ZlnfrMtfAb3k61jL
        +3usz1BvbZL0fJ6JA+fl63Q+A/asBVU=
X-Google-Smtp-Source: APXvYqwFpdxE+9uGybYAQFybT8oepdhoNzTdnCIywp4DyZ1VPld3RF/23XY6p4IgXIwtkZnG+7W1jQ==
X-Received: by 2002:a7b:ce1a:: with SMTP id m26mr3252266wmc.131.1554812638386;
        Tue, 09 Apr 2019 05:23:58 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v16sm45715047wru.76.2019.04.09.05.23.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 05:23:57 -0700 (PDT)
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
To:     Steven Rostedt <rostedt@goodmis.org>,
        Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com> <20190408150102.GA6430@box>
 <20190408111308.301f30c1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
Date:   Tue, 9 Apr 2019 15:23:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190408111308.301f30c1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 8.04.19 г. 18:13 ч., Steven Rostedt wrote:
> On Mon, 8 Apr 2019 18:01:03 +0300
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
>>> +++ b/Makefile
>>> @@ -254,7 +254,10 @@ all_cmd: $(CMD_TARGETS)
>>>   CMAKE_COMMAND = /usr/bin/cmake
>>>   
>>>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>>> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
>>> +
>>> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) \
>>> +		-D_KS_CACHE_DIR=$(HOME)/.cache/kernelshark \
>>                                  ^
>> Which $HOME would that be? The one for the user who built kernelshark and not the user who runs it.
>>
>>

As it is right now Cmake will get the value of the -D_KS_CACHE_DIR 
argument and will tell the GUI to save cache files there. And yes, in 
this case it will be in the $HOME of the user who built kernelshark.

I can make the GUI to check if _KS_CACHE_DIR is defined and if its value 
(path) belongs to the user who runs the GUI. If this is not the case, 
The GUI will use the default location (~/cache/kernelshark).

Is this OK?

Thanks!
Yordan



>>> +		-D_INSTALL_PREFIX=$(prefix) ..
> 
> Correct, this needs to be the HOME from the run time environment. Which
> is taken as the third parameter from main!
> 
> #include <stdio.h>
> #include <string.h>
> int main(int argc, char **argv, **envp)
> {
> 	int i;
> 	for (i = 0; env[i]; i++) {
> 		if (strncmp(env[i], "HOME=", 5) == 0)
> 			printf("home is %s\n", env[i] + 5);
> 	}
> 	return 0;
> }
> 
> 
> -- Steve
> 
