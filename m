Return-Path: <SRS0=JD1t=VF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303DCC48BE7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A4120644
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0HqmHKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfGHJQX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 05:16:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38739 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfGHJQX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 05:16:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so6031124wrr.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jul 2019 02:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LLWWE/PcjVnnQzzM4mU5Qv67a9DQIwf135Ot5vEeugk=;
        b=i0HqmHKVo0KuAh0sLKedUyRcKK12kQqVZYcPup+EFM9XlEHb935LEnlc5lzLFdOwUO
         f/jmsGFVdq60lWMUboAD3Zbautlh4O4FUC2zxH95FHQeyqKUwknW4O958IKLV1Ymhiwz
         6us3LMLQ8Nl0FtmWdXVtFkyYJrb7dhCwZwcuBMsgAT6e81yffQ0Jn/3+8MKcAgvaIRp1
         +eL2AoVgdp2G41Htz0dOhv6i6qXyIJjNWfi7oDd6Vuc0E4IqFWAkJYxa3WfUTuWLuMXV
         CeF27tLMdZpq4bSOBoHyb0AxSTAawQJx5PCoZLRYHqLR5a3mI30kDyftCF2Hqwl9J3Cy
         ajJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LLWWE/PcjVnnQzzM4mU5Qv67a9DQIwf135Ot5vEeugk=;
        b=dJdh/ukgJ/a2FKNvYOPHdCMBGi+6+pRVKCFkOjfJBQDbqcDjn5W50FtJTfZ30s71FX
         Vc5pNK9oKos0nyoW0/gr2r1wZvsZ0wjHjkZCQYmTzlcTK4ddSyLdlMv7AA/chDpuLm9k
         59NHMsL5ioBYe/8cyf5Lod1P1vbSwsvrf4AfJV3aV/TXFJpEuQwrCRPv4TTNqjdSReNJ
         Sbv3Wz/P/bp+x6gnvz6F/wL+BRiBVynsyUJh8bhSiu9i9ErZQ9MRZvzCMXeecUcst3JI
         OUQfFRxIyzRD23FVyTLYhS8FIHVRMQCXPemO2J2WWwohRRnfM0hNiAH4j4mnTGU5do3Y
         VF0w==
X-Gm-Message-State: APjAAAX4vnkf46nv+GqAYEMJsZbOrXuJIlNy04422KPcyufLfGHysHYk
        OV3VcTM8bViGodBkv85ks9I=
X-Google-Smtp-Source: APXvYqx75XAMcwqV0PmEQ5VkyOvGguFHact2rOyJBH8aHA6TC/ImBKgnN5WpYb+oP3+GjK2QlGisfA==
X-Received: by 2002:a5d:5507:: with SMTP id b7mr17512582wrv.35.1562577381178;
        Mon, 08 Jul 2019 02:16:21 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y16sm15827377wru.28.2019.07.08.02.16.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 02:16:20 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "troyengel@gmail.com" <troyengel@gmail.com>
References: <20190614132609.16465-1-ykaradzhov@vmware.com>
 <20190614132609.16465-4-ykaradzhov@vmware.com>
 <20190705193431.7594c3f2@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e3d051df-ff9c-ab70-eae9-66f97dafa005@gmail.com>
Date:   Mon, 8 Jul 2019 12:16:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705193431.7594c3f2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.07.19 г. 2:34 ч., Steven Rostedt wrote:
> On Fri, 14 Jun 2019 13:26:59 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> A special build type dedicated for package maintainers is added.
>> By default this build type adds the "-O2" compiler flag. Users
>> can chose their own compiler flags by providing the corresponding
>> CMAKE_XXXX_FLAGS_PACKAGE Command-Line options.
>>
>> If no type is specified, the build type will be "Debug".
>>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> Hmm, after applying this commit, I get this:
> 
>   <trace-cmd.git># make install_gui
>   <trace-cmd.git># cd
>   <~/># kernelshark
> kernelshark: error while loading shared libraries: libkshark-gui.so.0.9.8: cannot open shared object file: No such file or directory
> 

Thanks!
I see my mistake. Is turns that we need to set CMAKE_INSTALL_RPATH 
regardless of the choice to build with or without RPATH. This is not 
made clear in the CMake documentation. So the line

set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")

has to go outside of the IF. I will send new version of the patch.

Yordan


> -- Steve
> 
