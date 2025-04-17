Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08EF241CBA
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900756; cv=none; b=rF6ecKRWM2lQMwXdxC0PwSMrqT2flMYJLN2l8QjyCeA9fGzxoIVqG2xOuMmmJvCv5qWeUVE9fRVymDiMUkYGRKPOJBaMYBkynyzWPQ7jW1QfEyLD0eTKp1R/XYvWWc5Eg0LwJsQX4T4Ge4ebolXUZHt8qjyZOi0mBCxMfGfIC90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900756; c=relaxed/simple;
	bh=rAe5oCPyRoYe3CU6zMr91lZtBGPh7uMEQpJJGaswS0k=;
	h=From:References:MIME-Version:In-Reply-To:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V4p7JHzpaNpB4FCruKjLIm3wGIT3fd8mt29z80Ic12ikEXFSCSgYU0ZFszWuTUewBfyLrzRK9OtN15breqwboG+ysem/Qp7gKxwktmha3q2RE4Q8Wp72i0TGjD4lt8xlwsOQeTTVxBQKAmweHpjlHpc/vqRpwMxkZSX13hYC7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=V2uarN9w; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="V2uarN9w"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c5e2fe5f17so70937885a.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 07:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1744900753; x=1745505553; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3gyK7k79SYyywcvpGsdjhcI7xv0MyAbjYTP6szVoVWM=;
        b=V2uarN9wNHM4ER7rF2RFyAmxUurDEVGpW9PjNxzBrXNSF/8fqb7y2/v5x0buImVXNK
         csISnIHyaKiH36MlEYj1gTm3ZyUfeqQv1+gZZlaoqEsu6opSP1sNGr+7JNB4J/yns3zX
         Lz6tPgzgA/UhldvcJUt7YvtGtE3a86oB8hLumSbwTz2XmAjwggNRerM+oJGkC1AeYbbL
         cQaemyI0wHD26qr32wPLId1ZmcSVmwdjjSfvoFc2d4O5dLyuVCAdLNS/1LLhwMtyLOjO
         HCrWC7jLlI1Ck+5UOUpdjRSkoRFJb72K6Lu3sNwCaD67Uj4mA13ZfU0QZsiOnecxYyTx
         R0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744900753; x=1745505553;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3gyK7k79SYyywcvpGsdjhcI7xv0MyAbjYTP6szVoVWM=;
        b=kmM93Vb+qDMMzBSLNCkmeJfxLghjRfukWLSwVLifKXBUQBvVbW1hP4DKl9gqD0IEDC
         M+1aao6hFkRhYVQB819HVnD+DPx0uTzSGh0lRtFFFU6ERhVczPbkYZ+cgenG9FVLAglS
         FG+bBgn7RQTxWAOLy/8Q3k4ilto0bpLmCvo3j5ITY0nul4lPRP7mBv0Okn5AM3kHzuxD
         dGI8+WABiQUnu63Bzu0Zxc4Xq4bDGu32GoypVyZCzyRbeeB9IP7jAJHNtzdpH6cvGx0b
         wfkRvp68OosOl4tT6OwAo/TtG11N6A2025HNoM6x9CjModPNIqLBXVLXyXFM+FU922uH
         n5iw==
X-Gm-Message-State: AOJu0Yx4qefgCN7BSmvQK1HluCiM6A30GMYd0rSkjvXnXPsVFjkLL3Qg
	g7C3QMGlxievimrXe8z02aMi3NMyFRWjWfsjYNkmY5MxxZyl9xfzj33gnumqvCRu/oBnEjUdvxj
	I6cGCDuz0MJNBkeNP0vvNs3AqW49BgBCqHMxt
X-Gm-Gg: ASbGncs0k3cCBBvlJHHugmx0wIuJJmdTXohT0FeLmjKs2Qi9GV4W22Rud2+r8LFf+cY
	JDnhbTMh0yiO5ZbHbcnjwftSw8z38mSjaEDsFCkVo9zDP9pOrELj/CdfIML/+9/cbsM1kJLVuy1
	1VUh4aKI/vUtqHRITGfiBbCQ==
X-Google-Smtp-Source: AGHT+IGRrgmA1t9Xq9fM2N/GQQmeIXWDRsmj7aRxr8lQRGzITxs3bdCIyHwHXCnVAdcHpfnnN8H5L8z/tyvBnqNyKtc=
X-Received: by 2002:a05:620a:31a6:b0:7c7:a543:dcfe with SMTP id
 af79cd13be357-7c919002b95mr839027785a.32.1744900752794; Thu, 17 Apr 2025
 07:39:12 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Apr 2025 10:39:12 -0400
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Apr 2025 10:39:12 -0400
From: Petr Malat <oss@malat.biz>
References: <20250409110705.437321-1-oss@malat.biz> <20250409225608.12df6ed8@gandalf.local.home>
 <20250414114117.6346acc3@gandalf.local.home> <CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
 <20250417074900.15044cc2@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250417074900.15044cc2@gandalf.local.home>
Date: Thu, 17 Apr 2025 10:39:12 -0400
X-Gm-Features: ATxdqUHRy4pbWSk-9sT9FC2xgEQdYubK86_lTxkSCXsLWk7SEFc9W9Pw6fJCuaM
Message-ID: <CANMuvJkUM7m7byL0bRfe2eBb5wB8vhaMV7qzGpTymQ75Rxn0Uw@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 17, 2025 at 07:49:00AM -0400, Steven Rostedt wrote:
> On Thu, 17 Apr 2025 05:06:44 -0400
> Petr Malat <oss@malat.biz> wrote:
>
> > Sorry for the late reply, I tested my patch on mips, arm, arm64 and x86 and
> > it works everywhere, but for arm64 I had to add extra functions, because
> > it doesn't use the GCC __builin for swapping bytes. I have extended the
> > plugin and will send a new version.
> >
> > On mips using network order ntohs (and similar) expands to a cast only, so
> > the call to swap is not present.
>
> So if you record on x86 and read it on mips (or other big endian machines)
> does it produce the correct output? What about recording on mips and then
> reading it on x86?
Yes, it works (mips is BE):
 - when trace is taken on mips, then ntohs expands to a cast and there is no
   __builin_bswap in the print format. When that trace is read, it's then
   handled as any other number. So on mips nothing is done and on x86 bytes
   are swapped to translate the number to native ordering.
 - when trace is taken on x86, then ntohs expands to byte swapping. When that
   trace is read on x86 it's swapped and correctly printed. When it's read
   on mips it's swapped twice - once when read due to different endianess and
   then again due to bswap in print format and again the correct value
is printed.


> That is, do a "trace-cmd record" on a bigendian or little endian machine,
> then copying the trace.dat file to a machine with the opposite endian, and
> seeing if it still produces the correct output?
>
> BTW, libtraceevent also provides its own swap functions so if the GCC
> builtin is not always available, then it should use that instead.
>
>   See the "tep_data2host*()" fuctions.
>
> But that may need to be updated as "tep_swapbytes*()" and have:
>
> 	if (!tep || tep->host_bigendian != tep->file_bigendian)
> 		return data;
>
For some reason I was not able to get your patch working, it always prints
zeroes instead actual value. I tried to fix it, but no luck, only found copy
and paste error where you swap 64-bit int as 16-bit. If you want I can share
some example trace.dat files.

I will send my updated patch as a separate mail.
BR,
  Petr
