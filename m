Return-Path: <SRS0=JYjC=RM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6938C43381
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 21:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C05120652
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 21:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=opersys-com.20150623.gappssmtp.com header.i=@opersys-com.20150623.gappssmtp.com header.b="I42p6Egc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfCIVog (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 16:44:36 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39552 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfCIVof (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 16:44:35 -0500
Received: by mail-qk1-f196.google.com with SMTP id x6so653229qki.6
        for <linux-trace-devel@vger.kernel.org>; Sat, 09 Mar 2019 13:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=opersys-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eL2DXtq/rP8TZ2jDYm6stKjkD38WT1ewH8UCn9iYD+I=;
        b=I42p6EgcsXFpfzgTLZan7rfofg0KeBkp6V7wvWypbSB8xpTbYIW8en6hYzpCBVDaX8
         /EhjhiamXTcRTteu3xKkvru9BpZ4UZPswSa2/WCQaehHDQjytBIyuvuUzBpCFGrQN8ZQ
         uJwuvRkBeJPdi9x2es/7oKpNw7S2UU6Z5fZZFrTWyZbfUeNikl/U8z7+3GxXuHz3YiGg
         gybNh8lMbKdWmVoqQQg5/XCgpyT8hc2FwNaWSi8UFDA22hCZud7lPNzRi56FAtKpzk+i
         c2f2jGZpNmHDCJsgbEN27RIMP1WM3MvnQBCzw3luLGR8NZl+qsjXt/R69u4mFBtKpkfl
         p7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eL2DXtq/rP8TZ2jDYm6stKjkD38WT1ewH8UCn9iYD+I=;
        b=mK/6MdcJ80qdCXXmDCOKKOIftmmHDqF24CLEwSQLE150osViEwNN9NlVJ4hz/RRL5y
         6xP7B2sRsMfWFlCtyI+VSWkGKtJShIW1hp+qkNJGjZVEjF1ksiRBkCsuY34pQUx/lFab
         1mIAlPWZkLmVvSScW4JSRzrRIICokEDzb9McB5wOTDRGg5VZNz6CmQnwlYuXd+gZx+F5
         ++PDj+1hp3CKFvmKRCIzwkt4LTY93CSg8o9Fj13VkQafRl9J6SqKdm5DOQqSuL7z1y2d
         NM1qfBRgY04qpmrwLb3Nyi4uhYUG5RQEnFJrc0BCtAfPMw391iaa3ml7xgwGRiV0yQl0
         OxIg==
X-Gm-Message-State: APjAAAX6vG3g4atT/sKZIY4M2t1e1oo/GKHkYW0A1VOWcZOdQ6Vg5HQV
        F+jk1QaFhh6/zEe2lfBmaSQRoQ==
X-Google-Smtp-Source: APXvYqzV1SwgH9OQZSfuX3YRYuZ3vfMpu/xweCHGesn1cWWuK/Fy3t+3njQlFrfoCTYJpq4ZHMCM7w==
X-Received: by 2002:a37:4ec2:: with SMTP id c185mr19771016qkb.244.1552167874504;
        Sat, 09 Mar 2019 13:44:34 -0800 (PST)
Received: from [192.168.202.103] (modemcable170.15-70-69.static.videotron.ca. [69.70.15.170])
        by smtp.googlemail.com with ESMTPSA id r77sm832622qkl.89.2019.03.09.13.44.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Mar 2019 13:44:33 -0800 (PST)
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com>
 <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com>
 <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com>
 <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
From:   Karim Yaghmour <karim.yaghmour@opersys.com>
Message-ID: <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
Date:   Sat, 9 Mar 2019 16:44:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Geert,

On 3/9/19 2:26 PM, Geert Uytterhoeven wrote:
> Thanks for the explanation!

Happy this was useful :)

> So how does this work, with kernel images and kernel modules supplied
> by separate parties, not "bound" by the same kernel headers/API, as they
> can be replaced separately?

The thing with Android is that there isn't a "one size fits all". Google 
provides guidance, policies and at least one example implementation 
through the Pixel lines.

Each vendor however is allowed a great degree of latitude with regards 
to what they decide to do. Personally, if I was advising a team working 
on an Android device where Joel's patch was available as part of their 
kernel I would just recommend that they build it in -- i.e. not as a 
module. Hence, there would be no module chasing game.

With regards to Google's guidelines for manufacturers, though, Google 
states that CONFIG_MODVERSIONS needs to be enabled, see here:
https://source.android.com/devices/architecture/kernel/modular-kernels
FWIW, that doesn't mean that modules are actually used. Devices don't 
necessarily have to be using modules.

> Isn't the need for kernel headers for user-space tools something different,
> as this is limited to the uapi versions, which are less (almost not) subject
> to change, compared to the kernel headers needed for compiling kernel
> modules?

Sorry, I should've been clearer. I'm including eBPF/BCC into the 
"user-space tools" here. That was in fact my prime motivation in 
encouraging Joel at the last LPC to look at this. I've been integrating 
the teaching of eBPF into my AOSP debugging and performance analysis 
class (see CC courseware here: 
http://www.opersys.com/training/android-debug-and-performance), and it 
was pretty messy trying to show people how to benefit from such tools 
under Android. Joel's present set of patches would obviate this problem.

HTH,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
