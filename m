Return-Path: <SRS0=sBA1=DL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C706C4363C
	for <linux-trace-devel@archiver.kernel.org>; Sun,  4 Oct 2020 07:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5A5F206C1
	for <linux-trace-devel@archiver.kernel.org>; Sun,  4 Oct 2020 07:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4z29MiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgJDHH6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 03:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHH6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 03:07:58 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A35C0613CE
        for <linux-trace-devel@vger.kernel.org>; Sun,  4 Oct 2020 00:07:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id l126so4410087pfd.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 04 Oct 2020 00:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ji6Y1HB0oCNuuomGmT6DzCSO6hETiXk9Wsvg1cWEQD4=;
        b=n4z29MiQR5YfUZYZHxxpH+X6idzQPwK+chH7d5xi0vZPv/Ry7u0z2VG8Zmo8b2ONZS
         hlOXmz3jBcT0lHVZJ4dZWq7dM2C/+UN8iu+xIglJq5HMG6TiXVAdn3EwyuHEYZ8OP8RY
         yPKu1RiZaKdnP3wGfkBFuK+gO8l8zJflj30UUOKAb16LPEqAkDu9Awq3mfhZb2IG69yW
         OUJNETexwsVyouWiUEeOT+K6umuMSD6RXwDNmRHpw7njCI6pOg4KPFCF0zaSRior0shg
         HbTVajGZuJJWyWsqUBmJO4n4WUNci3tplhKvTUWqrSpHNYpyjBpshoZeWBFq0g9bp7J9
         MWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ji6Y1HB0oCNuuomGmT6DzCSO6hETiXk9Wsvg1cWEQD4=;
        b=WuLX0DFwFgclTXLgzivtKxW9Oc9vxEglX12LLMIsypewsUrCr6fTVt5kioaCRJULCQ
         S6SKP1egaUUUe1zgtfFI2/UN5bN+atm9IU5wx21ilM4I21k1FreEbpPMa2Ef1ECICnVx
         gUuzN0Ra3XKj+HOPb2Rh7ztaJqBvACcEuz7QlMRRJmMnhYR3vkDqkw+VFJGql13GQOLe
         oFz37IzY4f+ijKAeIiBjDmDcBX4MLTDPo79Z59UM92NeVJu+B7HDk1Y67fIyhuKscKf4
         e1PjQQOEGdksy4MQt2cx4fay+6zk2J3mrvo6X3tYlJiWQCSadP/GMaummbppf/ZQYh8c
         sZKg==
X-Gm-Message-State: AOAM533W/yhXVIDv5LGTDhR9NvmpecDvyg3GE5iabPPse/4Si6XEDLe+
        dXaCFG87fH20l57CZDp8XmQ=
X-Google-Smtp-Source: ABdhPJx6P5KnbTzM8dS+6fcTRqiC3zSQrb2wJEzGOk4GkHizA4iMInlRUFRGHvNqO9KcVs+XWgcOFw==
X-Received: by 2002:a63:e61:: with SMTP id 33mr8757394pgo.394.1601795277152;
        Sun, 04 Oct 2020 00:07:57 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id n3sm6922321pgf.11.2020.10.04.00.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 00:07:56 -0700 (PDT)
Subject: Re: Co-existing of traceevent of trace-cmd and perf
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tstoyanov@vmware.com,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
References: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
 <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
 <20200929111821.7e1199ea@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <f71567bd-6ae2-56d3-ea75-0b37e9597d3b@gmail.com>
Date:   Sun, 4 Oct 2020 15:07:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929111821.7e1199ea@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9/29/20 11:18 PM, Steven Rostedt wrote:
> On Tue, 29 Sep 2020 22:16:33 +0800
> Zamir SUN <sztsian@gmail.com> wrote:
> 
>> On 9/29/20 9:44 PM, Zamir SUN wrote:
>>> Hi,
>>>
>>> I'm packaging trace-cmd 2.9 into Fedora.
>>>
>>> Back in trace-cmd 2.8, all the plugins are under
>>> $(libdir)/trace-cmd/plugins. While as of trace-cmd 2.9, I find the
>>> traceevent plugins are installed in $(libdir) by default. This brings up
>>> an interesting situation - the perf tool also contains a copy of the
>>> traceevent in the same directory. So this means trace-cmd and perf have
>>> file conflicts. In terms of packaging, this means users can only install
>>> one of them, not in parallel (at least for Fedora). So I'd like to see
>>> if there are existing proposals or suggestions for which one is expected
>>> to be used by other utilities? Or is there any official plan to move one
>>> of them to the other directory?
>>>
>>> I'm copying Tzvetomir and Jiri as I think you're the first people for
>>> getting the plugins in this directory for trace-cmd and perf respectively.
>>>    
>>
>> Sorry, I just saw an email from Steven mentioning there will be a stand
>> alone libtraceevent. However I did not find it in git.kernel.org. So I
>> probably should ask if the stand alone version of libtraceevent is ready
>> now?
> 
> No but this gives me incentive to make it so very soon!
> 

Thanks for the info. I'll workaround this in trace-cmd then before it is 
ready.

> -- Steve
> 

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
