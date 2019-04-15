Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E45DC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED11206BA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bmp8Ml7T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfDON6T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:58:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53868 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbfDON6T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 09:58:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id q16so20784911wmj.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 06:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IWz3FAYrtNnykOf95J3Fhht3UqDPBY7gwdZ4k/bR3sw=;
        b=Bmp8Ml7TEhgUOYM6WqdK4YD7ofaEw/OcjuUbNKS2/kK4wgCLn5gPWSNHU2IAB45I2+
         2IHf3+KSxe5/IBAj8qzwj2ywfCpl0msin51LO+QO6xNcqkkM5ovpOaymUcSZtwdGM4ej
         L1Gx8XMZRqSEUXvjYkUcyE+SVslIUz+jLbYn2ThZkVYWq30sDvBMC+7dpdiOUYnSxr48
         LNYH7WRNvfooeXWgvISjyoCakVRPMqBf0Ah/tZxsVbNlmqagi2mmBTkXJJDhoPFwDvFf
         9tHDK+cnZ/ggFfCDRRTJlrw3TW6UilBVGDTMA8lTNnuTF+C9R+YzgvcAK22gDScWDgiU
         EcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWz3FAYrtNnykOf95J3Fhht3UqDPBY7gwdZ4k/bR3sw=;
        b=szLNxgnBKDidKrLmmVnJaIurIp8tXnK75ijRstpwFr35MANlqsHM7pliFmoQtzXGch
         XXwmwTuM1vj309DyIA943v7kOQRmLQ4YMjrCwYZoDOVLAk6fUeNPOiYgZOJlAkllBFsw
         PKgpWfwD2NSQdOVqSJd1KbAV7IQbf9ylNouYlJnnRGVFy8bZtWsu6/2y48QiLIVYMD+f
         WLqPkgHy5biHzEiw9n/67oGPl0yU4w+5HLJwcdjwL7fEI6pn+DM/nq+oeOnr9B2QuP58
         Net+HqHb+7t/RblegnBXmhN6oVz3NeX57flfHfW1reElibJKDp6xrVNLSJpaP3ZFbj2k
         xurw==
X-Gm-Message-State: APjAAAVm872CrmsKI21+n5nfjxKSeDiioGAvAg7UFL5vT1ZuNRicBzQl
        R4zj3mNVor9LvHHElpHRE9tvfIEJ
X-Google-Smtp-Source: APXvYqz0GlfHbwhZCBUMTKnMwqBoShl2W8Ubz8nuj82gwy8q1cUA7sZgbqzyUB1D7djpI66FU5k63A==
X-Received: by 2002:a1c:5459:: with SMTP id p25mr21752197wmi.20.1555336697447;
        Mon, 15 Apr 2019 06:58:17 -0700 (PDT)
Received: from [10.30.204.163] ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id h12sm48476111wrq.95.2019.04.15.06.58.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 06:58:16 -0700 (PDT)
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
To:     Slavomir Kaslev <kaslevs@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
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
 <edebede3-e508-022e-5d71-13226cd2df58@gmail.com>
 <2dc82f7955ca15cfe906ef98eb6980bdd14067e0.camel@vmware.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <46573939-59ee-0a28-cffe-2da981aa3ee0@gmail.com>
Date:   Mon, 15 Apr 2019 16:58:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <2dc82f7955ca15cfe906ef98eb6980bdd14067e0.camel@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 15.04.19 г. 16:11 ч., Slavomir Kaslev wrote:
> On Mon, 2019-04-15 at 14:05 +0300, Yordan Karadzhov (VMware) wrote:
>>
>> On 9.04.19 г. 18:44 ч., Slavomir Kaslev wrote:
>>> The problem is the way they are defined atm:
>>>
>>> # First search in the user provided paths.
>>> find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
>>>                                   PATHS  $ENV{TRACE_CMD}/tracecmd/
>>>                                          ${CMAKE_SOURCE_DIR}/../trac
>>> ecmd/
>>>                                   NO_DEFAULT_PATH)
>>>
>>> This will never evaluate to /usr/bin which is what it should be for
>>> distro builds.
>>
>> I think there is a bit of confusion here. The code above will never
>> search in /usr/bin. This statement is correct.
>>
>> However if this search fails we will perform another search that
>> will
>> this time search in /usr/bin. Look few lines below
>> in  FindTraceCmd.cmake.
> 
> Ah, I missed that.
> 
>>
>> The reason for this is to avoid confusion in the case when the user
>> has
>> the distro package installed, but in the same time is trying to
>> build
>> KernelShark from source. We want in this case the GUI to link with
>> the
>> version of the trace-cmd library that is being build (not the one
>> from
>> the package).
> 
> So how should I build kernelshark after a clean git clone for a distro
> build? In particular, what sequence of commands do I need to run so
> that I get fully build kernelshark with all constants pointing to the
> correct places (say TRACECMD_BIN_DIR = /usr/bin). If this is not
> supporeted yet (and I think it's not atm), we should at least have a
> plan how we want to go about doing it. A script doing something is
> always better that documenting how to achieve the same.

My understanding is that the user can do two things:
   1. sudo apt-get install kernelshark (on Ubuntu)

     In this case all libraries will be in /usr/local/lib/kshark/
                  all plugins will be in   /usr/local/lib/kshark/plugins/
            and all executables will be in /usr/local/bin/
            Or whatever is the install prefix chosen by the distro.

   2. git clone git://git.kernel.org/pub/scm/utils/trac...
      cd trace-cmd
      make gui

      in this case all libraries will be in trace-cmd/kernel-shark/lib/
                     all plugins will be in trace-cmd/kernel-shark/lib/
             and all executables will be in trace-cmd/kernel-shark/bin/

     at this point if you do:
     sudo make install gui

     option 2 became equivalent to option 1

and of course someone may decide to do both 1 and 2

Thanks!
Yordan

> 
> -- Slavi
> 
>>
>> Thanks!
>> Yordan
>>
>>
