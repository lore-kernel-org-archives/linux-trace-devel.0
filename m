Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB577C76191
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 14:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836E72075E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 14:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ohcbJDZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbfGYOAu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 10:00:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53422 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388171AbfGYOAu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 10:00:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so45117013wmj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GomAvNXaBSqcVI9jRv+cjI+OEHGhyGtVJzrhf20vSj0=;
        b=ohcbJDZsncO7x9ZLh1fijfzlij2eYuOLZH75D9GP4NDXQwSReNlWCaFawC8BwEctgH
         H5s6bGJg03RsuUmlkCDxYasH6R+g28Zk8mN//+maXZQBPnN5U3NHHK1HPeGBE9yXekXk
         UuEHZvrGh+jvN/bx1RjE95URvC1CwO3z0xs/AtT63KrZ78wf5XjOGbLtrRL+3f53H54Z
         EcA/v8qKlRvEpENnsEQ+U/920/Q5kqdMUCbvgVEONj9IOTsKLVpuAQN3TqVpj1b+8cHa
         IGjlC/WfGj3s+HJn2p20YQxZaxjZptqV3Ltp+rZZ25E6lJMs3qvYc7mOyGPdO6sGbQ/t
         II6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GomAvNXaBSqcVI9jRv+cjI+OEHGhyGtVJzrhf20vSj0=;
        b=RaGuprb3qRENA7VeATFXjUIOukSY/nR/9lm/84f7eS3NMeqXoD+JHc8Vz6Icnc6Zui
         7ZziEmSjscfhMfYcgMJXo3bvFUYK+9i7pPf0R2J9sLl3smmqVp3SpgFXVYxOsexAMyup
         nKhpM6Ei+zN/xs987/EtKbu/X/g4LBzkRrta9dAbYdzuWEeAmkOGZAawa0gLCs67lK/N
         LqPwiKgIuEfFz7iiuj4pbzOke0lt52dOR1mzyDxPHD5D+g6ocJthYNSNscghUa2/xdp7
         Uv4fqdY5mo2JXLemKs8/jNInA5gZKGcIWEGi+pC3ckTlgeRx0Zv/f8NRcf3h3qo8fddX
         l6Dg==
X-Gm-Message-State: APjAAAXy4XoM/Fsw4g3OunMwhombR1vlrqzlG0T682vFMHx4mkDBtQni
        8pcxsqCjnPgwU4t9CFx/nJZ1SX3Vi4w=
X-Google-Smtp-Source: APXvYqz/4GheqiDT5qLElJvg6+YUXwH4Pl/liYk9Ydj4wirjiYVHLEHsGYuUoKVXVUDWSXHRXxehMA==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr75585028wmd.122.1564063248293;
        Thu, 25 Jul 2019 07:00:48 -0700 (PDT)
Received: from [10.30.204.163] ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c4sm39518053wrt.86.2019.07.25.07.00.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 07:00:47 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Execute kshark-record from same dir as
 kshark-su-record
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190723225044.576298160@goodmis.org>
 <20190723225238.701263380@goodmis.org>
 <f9ac2e19-cc65-6496-5c42-9668337e6506@gmail.com>
 <20190725084514.410f1cb1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <14877974-6bac-9e72-3be9-c1d9c0439da1@gmail.com>
Date:   Thu, 25 Jul 2019 17:00:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725084514.410f1cb1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 25.07.19 г. 15:45 ч., Steven Rostedt wrote:
> On Thu, 25 Jul 2019 12:01:34 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> 
>> I just realized that there is one problem with the patch. With this
>> modification, you can use only the installed version of the script (so
>> you more or less depend on PATH).
>>
>> This will work:
>>    kshark-su-record
>>
>> This will work as well:
>>    /usr/local/bin/kshark-su-record
>>
>> However this will not work:
>>    kernel-shark/bin/kshark-su-record
>>
>> because you are trying to start with pkexec an executable from your $HOME
> 
> What about this patch?
> 
> -- Steve
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index 8c9fbd02a351..152d0cdff3e7 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -6,4 +6,8 @@ then
>   fi
>   
>   THIS_DIR=`dirname $0`
> +if [ "${THIS_DIR#/}" == "${THIS_DIR}" ]
> +then
> +    THIS_DIR=`pwd`"/$THIS_DIR"
> +fi
>   pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> 

I see that this works, however now I am really confused why it works.

I thought that pkexec will start an executable only from the path 
provided in

kernel-shark/org.freedesktop.kshark-record.policy

Thanks!
Yordan
