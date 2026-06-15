Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D6366548
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jun 2026 19:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781551551; cv=pass; b=isDeYsDUs5lIcRH8CJ3tSOIY22/+Oel+OldVQAQcOmtzp69sTxMo5DKu5KoTQWOoCXYsseQjfm5ck9OpF/tlQsVbRBBCSpW89K73gkVXVVh6uekIKpPryFktSX2oC6pMHRSY2L2hr12W2VsooDD7+UlePxz39Fx7dSuB4FmmzQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781551551; c=relaxed/simple;
	bh=jIyHh/K8m9QYXIQKUcb/B22sX5hj4JZT/xtviI7Gung=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W0g4LeyMZc5gU2S8QF3oufcHCTdiHXRBtJN4hH8jSJ6MsEahSMlIGlvizgiDrtSe+0KYhvm6dgVwYNFLxxCK36v2ht2cD2mA1zMLho7KeoiKJjBQkwwNyxP/pnO3uHv67bT05WoiYLCQOI1RS2v+YhBejKIGw9p/fuP5cGyuKYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mD+/ywh3; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mD+/ywh3"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68d05f6b3cbso682887a12.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jun 2026 12:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781551549; cv=none;
        d=google.com; s=arc-20240605;
        b=OlfI9xplRXxoMhUnAI366f6GOubKoSxz8X7c0zSviIVCssG6CpolnLlL5YLoUf3boq
         CnnvlIXW3z8yy7pn/aiH5+C+Qx7KS7joIodwFo0Mb8xZWG3SYBUQpYkAWZTFB/YEE44s
         G+dldjrBOxCSQFSpHzBUrVFc/TWs144onwYdJB8l5pq+Lr2/h/ShasoLsPLSf5w1pg/t
         LS9tYa8m+xPRf1xrUQcY1K78EEqkqY27VbKm04PrinnXi7Bw+lSpJ7pQbLSeWnmF84Dj
         J1049O037iIgbCynixa549vMSY8t0FTjlYBhjABNmSKwQk6r8lRrepKHkSahWq5iSBD2
         +ZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LzAhdKy5/r6RHc8E2p8OeDYxYkBTBPzXQm4mqGWc16Y=;
        fh=jXNTMpgLrQ+IoSG+YU+ClMKPuQbYdElqaX/erLz3aOM=;
        b=dGPwPAXc5TG5XdVWcV8eDoKc69cL6r1/FWboMMYAJKla5M37fb691F+02FWynBn7Kg
         bT+eMB9C5FDpv2dnjVPuAEFkiLp32wk0OyBy+FU5z7E4n9yL8k898M49k0jPZRN11oHf
         T8xMSuU6qW4eREWy6LfLQR9Yo5BykMf3pBjsDoJqyvHLJSo5poA22Zz8ibj9OJYWAVS1
         2BC3OR3vcGWbBtFFR4VW5udBDIDqb8UwLQrb6B57YVJRtUNOFsKpqJaa9NjBsqRXLF3Q
         bptmM4sCYLQhZF6emp9m5Fi3gxf7Ew5Ca6C72zuwZPjNmYwgTy9CqaL4RxZGC4n2xdtE
         jPEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781551549; x=1782156349; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LzAhdKy5/r6RHc8E2p8OeDYxYkBTBPzXQm4mqGWc16Y=;
        b=mD+/ywh3LBTuZL7ycJe37xBQ2yeC5XVsRLWNy6wuo43giDdGi+JqmSP2Fgpp22Pjbl
         0Ii1lEUz7BVNH00LsPVUXkIVhbv2WuB8gG4sJmT54XUqAhWl9kuovwPzm630VvpK2RYx
         Aq23UStsKW4TLaWyxVdUENBnxptU5nx2pRataSqUEn+LfUfUjB5gybxOh5PjdDjbtFZc
         lT7S7uOyETAm3/JNorxFX95ZSUksj8R2RNTXcnMsQeGMLqdfTzhJoo/6zm4n/knbP3U1
         meYUYydz3dKv3Kb5RsJUR/m4/nnPJAK4dd7RH9nHn0gbPqU9LEIwnrwfRo2a4ZbEM3ul
         oveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781551549; x=1782156349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzAhdKy5/r6RHc8E2p8OeDYxYkBTBPzXQm4mqGWc16Y=;
        b=p27WFmQfGjUay7DZASyzxQihGLwSne9bZJspCPmCUfV9ehxD8J4O2Of2D9viY7STIS
         qMkADb2heTFEPdq/lAhI9Y0HYqlx6p2uEyrMYhc11IBxQ1EXN1xlph7T5YyV7SNmS8JY
         3NT6xSSNtS6hdRBIUbtAhIbTgN2QsfVrkqkWPCfw1gLYD4J6vuNNre4MBjkBJ7R39PoJ
         Yw0YtyFexXeOMQyq1Quw1Ghfbqy2qcvXQeCyFbF0cifAL9c32a5yUFcUno74cpJFMApa
         BJbJJfgN8OWeKl4RzFvq/KWNBtYrlskbGfFZySZ2Z+4Ub8befLnyWvvY02nqq6a83jBG
         FS5w==
X-Gm-Message-State: AOJu0YxYmxBT1iWsN2i1TW0SWC7W1DbL4LfVoA0nyPx4Us+JO2ODdAsQ
	p4WXegNYURRC9NbqNjoRXeQXHFCUEjN4d6I+JRz+DMH0R2lYl1RiZFsh0N7+Qjn7XsGhVtwgdA4
	QBk5NB2KRYQ5KU+GpP3X96Ysq22zc+rY=
X-Gm-Gg: Acq92OHhdkQo5y491UieiMtbgFxj+/X4saSeRS/HmwHyLLsX6rv/aSOj335RS/d2Xrz
	qwq49dwBj75A4ZpzlDUMbZALoLcMleTBxyoyfI1kLgZIKinVahk2laC8hAYcMZ3AdAoOaBOLFUj
	7f0vl/LpKBphQyrc67W/L5044jw7FBKK/o883vtJpVxJflO9Fs/gn0g/vpIPCsqxBOG9gwQEZ6q
	TB9BtVIFirrQeQEcZDTcPuee0gtmTffT2RJib2kW939M1laYccsVJXKNHp4shgXgePaWrmgevex
	pPVLXw==
X-Received: by 2002:a05:6402:430d:b0:66e:4395:e920 with SMTP id
 4fb4d7f45d1cf-69378ab1b87mr2954359a12.7.1781551548255; Mon, 15 Jun 2026
 12:25:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com> <20260529144124.14954a5f@fedora>
In-Reply-To: <20260529144124.14954a5f@fedora>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Mon, 15 Jun 2026 20:25:08 +0100
X-Gm-Features: AVVi8CeKHmMK83jX9eq73-MFvFRqG5XXwQwUJQBQbsJg4kCVraLgyPv12HgCj2w
Message-ID: <CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

On Fri, 29 May 2026 at 19:41, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 26 May 2026 19:42:19 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > CU_TEST() continues execution even if the test fails. It just records
> > that the test has failed and moves on.
> > So, when libtraceevent is built in a chroot, it can open
> > /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> > does not stop so we get a segfault when tep_load_btf() tries to use
> > the mapped buffer.
> >
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
>
> Thanks, but the real fix is here and I'm applying that one:
>
>   https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/

Tried it today, and the test still fails for me.

Suite: traceevent library
  Test: parse dynamic string event ...irq=0 handler=hellopassed
  Test: parse old dynamic string event ...irq=0 handler=hellopassed
  Test: parse full cpumask ...cpumask=0-63passed
  Test: parse empty cpumask ...cpumask=passed
  Test: parse half-filled cpumask
...cpumask=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62passed
  Test: parse cpumask spanning 2 bytes ...cpumask=0,15passed
  Test: parse cpumask spanning 3 bytes ...cpumask=0,23passed
  Test: parse cpumask spanning all bytes ...cpumask=0,63passed
  Test: parse sizeof() 8byte values ...int=4 unsigned=4 unsigned int=4
long=8 unsigned long=8 long long=8 unsigned long long=8 s4=4 u4=4 s8=8
u8=8passed
  Test: parse sizeof() 4byte values ...int=4 unsigned=4 unsigned int=4
long=4 unsigned long=4 long long=8 unsigned long long=8 s4=4 u4=4 s8=8
u8=8passed
  Test: parse sizeof() no long size defined ...[FAILED TO PARSE] s4=0
u4=0 s8=0 u8=0x0passed
  Test: read BTF ...FAILED
    1. traceevent-utest.c:410  - read(fd, buf, st.st_size) == st.st_size
    2. traceevent-utest.c:412  - tep_load_btf(test_tep, buf, st.st_size) == 0
    3. traceevent-utest.c:429  - strcmp(s->buffer,
"getname_flags(filename=0x7ffe7d33f3d0, flags=0)\n") == 0

Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests     12     12     11      1        0
             asserts     46     46     43      3      n/a



-- 
Regards
Sudip
