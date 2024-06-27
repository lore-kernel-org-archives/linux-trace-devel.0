Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E33BB2E
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jun 2024 06:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719471195; cv=none; b=SAJtOiJyVA1d0UwFeM2Xe3+0efdG56xvNDu9stJmr2TaKMADB3dHZPIBayJ7VtL9e83dgG9cKfa7nttTN+yrmraECwZswPpR5T+w6JrvsNXATpemctwfzVN1oq/eBxPtpfBGbSL7apmZRY4DtULWrJmt/tBztxAx0kwA9g7DRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719471195; c=relaxed/simple;
	bh=f9XYbrXP+O7jxTEQU4N/tkWPVxH10/iGxP9lZD/BE4U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=LpMZ/jeSTcAQ1J/iozRiyxNHQQAy8ymLdCKm+lPYDuswR2XL8bcAeemHABKCOzCH93VOYCZE8dbWLfJCeJbV7OzQAX9Fq8d8vic+lwF6U6AW3QMHopY1qwG0XW5sTUgRUplG8orK6OrkOrMrLJyz0RFj8i+RHMkf99izUUr/cHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vq8u/TEi; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vq8u/TEi"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e02b79c6f21so7544658276.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2024 23:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719471193; x=1720075993; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TkunAp/MWizz+V8ZBB0Ycuq95mkaeBogkpxVgkrhi3o=;
        b=Vq8u/TEihkAxKreFVf2//NiqquQVBdrdo2oB0zhHYmdGhD5T/hBcH1VPMOqKvgonim
         SRmNHyxA6R40nBOFEtUNk2bW4q/sV+7QJOWzA11QA5kQZpxKftyDHX8OLIPtctDAYruU
         M6CDEhWxlbjGim+RHkhSSVDCTJxOzl0Dh/GaYRtjigQPqiIpKgm1tPhk6/wsseNBlY3p
         mFCOZHjJlbFm6L2lmlndQFRrBf20zLS6TxNgpRc+Vno48Jxrb0KeGGc4NQZejKlVKdhw
         8WfbQjINE/lqmwhYvfi/7cb42AlxBiLT5qhg4e7Fyi3DxLiVK4B12vGekHMgcZMsfUGc
         iHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719471193; x=1720075993;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TkunAp/MWizz+V8ZBB0Ycuq95mkaeBogkpxVgkrhi3o=;
        b=jS9r3EMqHq0kokoBiSbsfDFwv9TPvp+UhGFMHtE3tD5JD7QeliSA+zeDHV0DoGA3M/
         ADis8Y6ST3Bmzf9MZayWydqX8Xfq2LhUkCLk74p42hONGWDJnXae/PAj7DVSgXF1KPWn
         PtmZXX75vAn3zdmSe8OzqSB3ksPAV6ld1jeyOuZMr4ofuMZNWWY7/O2yPxQLLavcFOD5
         YX1qH7MWuf4/CHNQnV///nGm9DCzwUXjrrmiDiNP6B7XovpbAWoskovAdd8aVwmbjZVg
         jJ3sZwNlTHJ/I2sjod0HZXHGxQ/r2z/h78mjiyOruXCixbtynfR+ySRNkafBM3Gy1iu/
         8uJg==
X-Gm-Message-State: AOJu0YwD0dNFBA6dAccgxY+2zmE5QmTNC6hZufKfoGAEtOk+fs8PFe9f
	WeYBzPANSoRUwgS/eqtu94fzF3IgJ7zPwDBpIjS9iDI3TT+MnBlvw7jo5qgi8EuijfVtHUfwG10
	P4hKbwnpMWbI/W5qe3iCDtYOJORoIDpoqgcsGzVEO
X-Google-Smtp-Source: AGHT+IF3BVxIw5PPBY62KFcUdDIHNDL1c5mIv5OsNTP6ghHMtNtcHaoOHNqTF+p6vHzHztfh52F70WzpJ8FK/tfntsY=
X-Received: by 2002:a25:dc4b:0:b0:e03:4b63:43ea with SMTP id
 3f1490d57ef6-e034b6348cemr83342276.24.1719471192745; Wed, 26 Jun 2024
 23:53:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Totoro W <tw19881113@gmail.com>
Date: Thu, 27 Jun 2024 14:51:42 +0800
Message-ID: <CAFrM9ztDcGK4aP51uJEsQStyyf1tXebOKXiT-Ota2-gT3wVLyA@mail.gmail.com>
Subject: [PATCH] fix double free issue in event_read_print_args
To: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

commit cb227dfc63346a23fd019f2146b4f9f4f5a58b6a (HEAD -> fix_double_free)
Author: Tw <tw19881113@gmail.com>
Date:   Thu Jun 27 14:40:09 2024 +0800

    Fix double free issue in event_read_print_args

    The corner case is that when we encounter a invalid right argument
of a condition operation.
    Currently, we free token immediately, but it will also be freed
when free `arg->op.op`.

    BTW, the crash calltrace as follows:

    Program received signal SIGSEGV, Segmentation fault.
    get_meta (p=<optimized out>) at
/home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
    141     /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:
No such file or directory.
    (gdb) bt
        at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
        at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/free.c:105
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1128
        list@entry=0x7ff7b18768)
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1417
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:3895
        sys=<optimized out>)
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7824
        size=<optimized out>, sys=sys@entry=0x7ff7ff51c0 "kvm")
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7882
        buf=0x7ff7b0c610 "kvm_sys_access", size=549616874800,
sys=0x7fffffe0b2 "me", sys@entry=0x7ff7ff51c0 "kvm")
        at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7945
        tracing_dir=tracing_dir@entry=0x7ff7ffc660
"/sys/kernel/tracing", system=system@entry=0x7ff7ff51c0 "kvm",
        check=false)
        at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1062
        system=0x7ff7ff51c0 "kvm")
        at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1084
        tep=tep@entry=0x7ff7ffc830, sys_names=sys_names@entry=0x0,
parsing_failures=0x0,
        parsing_failures@entry=0x7fffffe7b0)
        at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1284
        sys_names@entry=0x7ffffff880)
        at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1355
        tracing_dir=0x6500006c6f6f62 <error: Cannot access memory at
address 0x6500006c6f6f62>)
        at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1377

    Signed-off-by: Tw <tw19881113@gmail.com>
