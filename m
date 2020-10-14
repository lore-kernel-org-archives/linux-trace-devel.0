Return-Path: <SRS0=7UrD=DV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D86CC433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 12:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E8C21527
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 12:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlENaKN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgJNM5E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 08:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgJNM5E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 08:57:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09737C061755;
        Wed, 14 Oct 2020 05:57:04 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so1700177pll.11;
        Wed, 14 Oct 2020 05:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ddNuphe9QLvv723jEiiTGYlkmDCVLpyPL3ND5cQZato=;
        b=LlENaKN2rrAFSqLfVz0l5rqoNCFKSIeZEdnhtvSLChcmvGgNutQslBYJRkxGag40zv
         BNlmToFtgNi1mSzemXfirAJyZB6SkQb7gUOkxPInfNYZdS/IBKtjwQEC8BBalMv+ph1w
         eUsWYg7ghroDQqo4mQs8+rw/MXViFhwTJGFKHmQM5r4AP9Wy/9iaZnf1DxwDYxlzM0Yv
         serduIc8cazUL2Kgwwo1RTnhJnK/kLi3dSR5NmQORhT6E36pU557JL3G5ZKyNfGPQ/zB
         N2RVFBGFtpHmjrH2nbL8stXT0bZ6uRgXXRoNQVfeK1qMRYXbxUeNLPMW1Z+8/STbmuxA
         s7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ddNuphe9QLvv723jEiiTGYlkmDCVLpyPL3ND5cQZato=;
        b=UFY0kKxCPkAaNtFsZzQlKxKH2jJErQFMUbzIIqoXZpa2ceXf24chOeXXIwAaC4mC94
         qKskgn1czZLNLGCcsf4zEqrBcLdvUGb9kx85V8oFagfvEnG/I69TG0066kFaWaVpx5Uv
         VhJu6BGTx5kGRi9/TTsEBW6Oe1KQtybVZj2zVX7mQB8Ptw3mqU4NZEcjHUcUVrK1uOsj
         Gl2s8EroBAkKLS/Zm9WCHZOPWb3oCnTjLwDpC9YZGyvom9+/Q5xh0Sm0vNISP4PZ3r7o
         XLETg0jVAQqVwwe1SAIXs9bHUtIS8iuZrlsxd9gLRvUqjPQM71VkVsHPjl5smLz2ag4i
         tKMw==
X-Gm-Message-State: AOAM532QNqoFdMQSkcat57bcK80EhMvZJ+3anTZyFrBCRN4pDMGt1AkT
        s19yq14UqZr0UptLm0z3J6w=
X-Google-Smtp-Source: ABdhPJxTmDA36LC0xThExb1RH2F8KLXbTJ4EbMwlVmh6PW/3sv3BaO9BDfs2bdSbXGOI8KtU7tK6Uw==
X-Received: by 2002:a17:902:a5ca:b029:d3:7d11:2a80 with SMTP id t10-20020a170902a5cab02900d37d112a80mr4262035plq.58.1602680223533;
        Wed, 14 Oct 2020 05:57:03 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id f17sm3407691pfq.141.2020.10.14.05.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 05:57:02 -0700 (PDT)
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
References: <20201007130750.49349844@gandalf.local.home>
 <20201012101208.GF1099489@krava> <20201012111950.55a73588@gandalf.local.home>
 <20201012184120.GN13697@suse.de> <20201012151732.6e439886@gandalf.local.home>
 <CAHnb8o61XwvgkMnryaOv-=qCDf-o5OpezQAAk-44R+KgCc8Vcw@mail.gmail.com>
 <20201013090228.78256290@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <7997c7e5-481e-a1d6-d785-f1ed18ebf3d4@gmail.com>
Date:   Wed, 14 Oct 2020 20:56:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201013090228.78256290@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10/13/20 9:02 PM, Steven Rostedt wrote:
> On Tue, 13 Oct 2020 11:06:16 +0800
> Zamir SUN <sztsian@gmail.com> wrote:
> 
>> On Tue, Oct 13, 2020 at 3:17 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>>>
>>>
>>> [ Removing the powertop mailing list because it's rejecting everything ]
>>>
>>> On Mon, 12 Oct 2020 11:41:20 -0700
>>> Tony Jones <tonyj@suse.de> wrote:
>>>   
>>>> On Mon, Oct 12, 2020 at 11:19:50AM -0400, Steven Rostedt wrote:
>>>>   
>>>>> Once it's shown that it works for all the package maintainers, I will tag
>>>>> it which should create the tarballs automatically on the above link.
>>>>
>>>> Hi.
>>>>
>>>> It builds fine for me after manually creating the tarball from git.
>>>> Once there is an official versioned tarball I'll push it into
>>>> openSUSE.
>>>>
>>>> I presume some perf Makefile changes will be forthcoming to use it,
>>>> rather than continuing to force build it out of TRACE_EVENT_DIR
>>>>   
>>>
>>> Zamir found this issue with the Documentation man pages:
>>>
>>> Note, I'm not sure the proper way to fix this. I think this is the last
>>> issue I need to resolve before making the tag.
>>>   
>>
>> If anyone interested in, the discussion of this document compiling is
>> in the thread "libtraceevent: make doc-install tries different file
>> names than generated".
>>
>> With the patch Steve mentioned, I can package this in RPM already. And
>> it's pending review in Fedora now.
>> https://bugzilla.redhat.com/show_bug.cgi?id=1887470
>>
>> So, for me, there is no more issue for Fedora packaging.
>>
> 
> So should I just add that one patch and tag it?
> 

That would be great, at least for Fedora packaging.

Thanks!

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
