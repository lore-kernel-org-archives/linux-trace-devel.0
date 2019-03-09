Return-Path: <SRS0=JYjC=RM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB12C43381
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 16:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C421F207E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 16:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=opersys-com.20150623.gappssmtp.com header.i=@opersys-com.20150623.gappssmtp.com header.b="vz9ldWAj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfCIQwA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 11:52:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36393 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfCIQwA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 11:52:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id c2so422713qkb.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 09 Mar 2019 08:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=opersys-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CzCi6t3ZPQtB+NT+TKbpBOV2X5on6B/x2k+goTmH26U=;
        b=vz9ldWAjDzpinsxnZw0qwZUvghaznfRMSSYJYyXiaQWsz08TTurhsT02ACDV2Ubp+X
         DTxyOvW6+N+NHgJIboB7UgIEgigImyAm6YixJUppQVbi4oHw7mhNODz2JwPx1IWm+WQG
         /EEJawDwPHUgqNBvo/ogahZvuxY9JDifxNJFkk8dmDBWxc01vhptbHd7xmf7EBsKV18K
         4oOwzthm3efU2/jhaBgHA3jUpvDmmUJ4FpPccfh3USPF/c9obzdOTIXPynjhZnPPWdKL
         M+lBEkcNjNjKO5x6PiQwmnsfGUcckRmc9P7YF79wftsXfAeBoF1rMJ+i/X/6zYKBIKQW
         O9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CzCi6t3ZPQtB+NT+TKbpBOV2X5on6B/x2k+goTmH26U=;
        b=apOof6lNp6jajSzsx2qEzzrgyUi3oTfN7LWKRHz+ts3nP1k26MSGgOG7vfEJ9YhLhP
         6k80tcTpk5f1VZ0KYlQDlT9RcImoTgo8wU1KoKlE5BHRUGHwfaJmAK+yRjN6oig/Aw29
         jpdsrXtQV6+6Ik76iZAu2mpwZFenpa4DcgXginNqbSX+tAEsU5MpkDtH+Ozb7b1qXbOk
         LH2pEjQ5rHi2LK0GjNVYX6a/YrDlBDb42VdrqIn5Cvj6qfT62OYEl9+saux2cU3k4tBr
         KCXvAXUA/EcClCFVTdiU8K91piCiv7CAjyeOwh2Wy0Rv6Cv9YjXT4sybh0irku4yCgh8
         ep9Q==
X-Gm-Message-State: APjAAAVaFu5E2R9tf8lGrXYhQju+UerBDEv42p2xOuh3M80jfAwf2IaX
        /KNsBPmli6Hn9FfZssKSOBb8Mw==
X-Google-Smtp-Source: APXvYqyKWPIAcW2u+9NM2t6v+1t+hfENGZw+lz5lg+opK/wMVn5lnWEUk8LPq7HRH/QuSyBhueprgw==
X-Received: by 2002:a37:c40b:: with SMTP id d11mr3841605qki.62.1552150318441;
        Sat, 09 Mar 2019 08:51:58 -0800 (PST)
Received: from [192.168.202.103] (modemcable170.15-70-69.static.videotron.ca. [69.70.15.170])
        by smtp.googlemail.com with ESMTPSA id x15sm467115qts.21.2019.03.09.08.51.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Mar 2019 08:51:57 -0800 (PST)
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Greg KH <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
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
From:   Karim Yaghmour <karim.yaghmour@opersys.com>
Message-ID: <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
Date:   Sat, 9 Mar 2019 11:51:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190309121141.GA30173@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 3/9/19 7:11 AM, Greg KH wrote:
> There is no licensing issue, see my follow-up comment about that.
> 
> It's all in ease-of-use here.  You want to build a trace function
> against a running kernel, and now you have the header files for that
> specific kernel right there in the kernel itself to build against.  It
> doesn't get easier than that.

Agreed.

It seems that opinions in this thread are split along two conceptions of 
a "Linux system". On one side there's that of the conventional "Linux 
distro" where the entity generating the distro has full control over the 
entire process and the parts thereof. On the other side there's the 
world that has evolved out of the multi-party ecosystem that Android 
fostered. In the later, there isn't a single party that controls all 
aspects of the "distro". Instead, there are a multitude of parties 
contributing to creating a fully-functional Linux-based system.

In the latter ecosystem, the kernel and the filesystems (*plural*) used 
with it do not necessarily come from the same place, are maintained by 
the same parties or even required to be in lock-step. For all I know, 
the filesystem images are coming from one party and the kernel is at one 
point from one party and at another point can be substituted, possibly 
for testing purposes, without userspace images ever changing. No 
licensing issues at all involved, either with regards to the headers or 
the distribution of the kernel itself, which, in as far as I've seen 
when speaking of known industry players (those that matter here), are 
always ultimately available in source from somewhere.

Instead the issue is that I want to be able to give user-space access to 
the headers that were used to build the kernel that they're running 
over, regardless of where this kernel came from. And since I have to 
assume that those two parts (kernel vs. user-space) are coming from 
separate parties and can be arbitrarily replaced, there needs to be some 
form of "contract" between them. The kernel's ABI already provides quite 
a bit of that and, as Joel pointed out, Google can enforce a few more 
things, such as default kernel configs, to "make things work". But one 
option that doesn't exist in the world Android evolves in is to somehow 
ensure that the filesystem images somehow have kernel-specific 
tool-required artifacts for every possible kernel they may run against. 
That's just not possible.

That's especially true in the case of modern-day Android where the final 
system is made of at least half a dozen filesystem images with each 
image possibly coming from a different party. The /vendor partition 
(with the hardware enablement), for example, could be coming from the 
device vendor while the /system partition (with the Android framework), 
for example, could be coming straight from Google in the form of 
"Generic System Image" -- an image meant to run as-is on any 
Treble-compliant system. /system might have the tools for eBPF, but 
/vendor might have modules, while still the "boot" partition might have 
the kernel. There's no reason I can't replace the boot partition 
*without* changing /vendor. And there's no reason I can't replace 
/vendor *without* replacing the boot partition. And all other 
combinations with all other images.

That, in my view, is a big part of the problem Joel's patch solves: in a 
system whose functionality requires multiple *independent* parties to 
work together, I can still get the necessary kernel headers for 
user-space tools to properly operate regardless of which part of the 
system id being substituted or replaced.

Cheers,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
