Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782641;
	b=oFi9tmON/M+Fg++oxLWjaL31AVJcupdBVNe4h0V1UFytKXfLhDLFp5+gdhSPdLA43kMP
	 XLCcLdAznL2J1f/vD+OI93oTUnjvCEJTRYpKZqJXpEf9a3IrILLqegCVp9y6SqQTTRsNN
	 b63GAgUpO+tMr1HJfrXUjUqWDY4YV0p9aj5ktw2KS2qn2qNjknoLr8wfUzJuts0EipWzF
	 OpCuQIxKAt9xuy2YxTMD5gu71gMf02JA1a+8zea0+66oI/gv4qlWnu/pPmHW0w9bT7zVh
	 6Jxz4D2cVrgKz8UWPrVSXjDFzVBRon3iHwRQaSnSOcBno/Tm2IonGV/op0sYjOdqmoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782641;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Date:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Mt5zz1kzDOa8Yc+kd0Mt5WqRtsECABRm4RrpiwMfjSM=;
	b=GjoFjeQB+4UZFbXUdjs/suukSTYgWnXZn/RGGI8fv/oLieV294ro3DjHnBdNu4CNt6Ks
	 SwjU20yowUIXpFDe2QGz7d3Xq9AAdTij0dYCS5QreIP4XKBW87vvua+bo0QGH9mTRN8ck
	 sm8G6B33cLI1rB9DC0qsBgmBkF16MdBFg+N/Wi5Nn212ozqhL6KyR3Ly0xOWv4PYi2OS6
	 m0SKPtwPN27vqjqcqOwXTiDrBXdFdbxi4H4Suggped6n80ZdbNXsMwBpBpuCMPxXAjS0Q
	 tLdas92lgP6XPhFcG27Ax43gtp4mi3BTvr0KOMHvItFrMvwpSRpRMT/Ip4bqJKKph/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=D7xpo+KF;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE30606A31A
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 19:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBE30606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=D7xpo+KF
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 15B044013F
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792782638;
	bh=Mt5zz1kzDOa8Yc+kd0Mt5WqRtsECABRm4RrpiwMfjSM=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version;
	b=D7xpo+KFBgilgg+1Y7o/PCpYA5IH/7VQ3VaN/ZssB80SiaQgJi5uAGZW1wcRxiUW0
	 wl/TVa+k5V9UTJfqvIYi2Iu/EEFnYbo1pkBP+XZ/q3Jhlnimt3WxuaPMhNcb4OCnUh
	 XBWW0jHl60kpC5tg2ux54NFm782OSexzC5vWf8tVWhnl6mvqqBUXHxVr8/I7vJ/uLm
	 Q8iX5FgVtlaXjU52RJrcQfp7HmeXhVr8wo7wAxUTNhseYGgI85+CTpV9Hd0cf9ZVWm
	 Av670yB86oxlesdwZCMKE5jd504kwgQuJDpDBDGWJoU7uFQ4HLl/1nFm/HMAFSbmyV
	 AEfo76+LgFKS5lAyZnbckOqSRI1lvBf7T4uSuFoCWg7Ds1388HhW0cSAfxwIUqP0co
	 iLBCXJaarpymqGcBC5Y4GRG25hcHKZ3G55yowMXFWArPiJ3PSJRtBdB8S+qosE1LtZ
	 2sLkgf4kJP915tbNlxNRGD8wmDAW1xradnDlc55oZyLEA/3jgCtjU9uFqoppz0N4XV
	 VJ8TeNbjElHU7OA5R0PzMl1YGGgg6+fG7FLI4XD5uczYWEww0Yu8y6Cy2T3CkVd5hL
	 FNUPasqtg/cJQZHzylnKP1VDOhmI8Yy1g4n8j0s/ksewVsfiag2jc1EZrwdhM144qG
	 dqWv7ohEtyTqhw/nS4PZ1xwA=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b3f6d9827eso1012090a12.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 12:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782637; x=1793387437;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Mt5zz1kzDOa8Yc+kd0Mt5WqRtsECABRm4RrpiwMfjSM=;
        b=Hlu4hxsgIHtjq58FZKA9r/Yi7Cy47MCPcd2NzRGExjHRVvPsMZNuYq+PH2ktU3RBlH
         a7pGtcon3/K+teAdHcfqDk94zO2eMz4PeC8l3Qzw723aWYf8S5BbqW5llqFS7PMRzQvb
         cMEQP6spuCUtqPHkuvqAaGQ/a4eqsXt81tLz3kcQoeq94afNJYLgRk5TkC17YVktARAT
         K/B+Qv07kZNz7MIm0D/jBHtO3IFzc2WRb1b5mi24FjENywDRZGdXhMaymi+UzH9vAWk1
         lSqiGjrYxRbvn0OOiW4EcnVu3nbdj8SaPGkhaLCfNbtCvUEWnBJXIAC+qvjfsnZkjnzb
         g9Tg==
X-Gm-Message-State: AFq9FYJUekFceQ4OpiZFfN0LmS7TDODJ6OPCEgQiHwXx0Up/84P3tWr0
	02UPrfc/Z18ai5w+BaJbuD9bLpb4d1ZTt0F2buoHSWll95j0KOB/ICO8ThDOfOCV2NMjjK+whzO
	FXbCFHCEjWojU8+FVqd+jYJ/v1IuFq1UEUndRVE8jh4i3cyjE5uFY9IrN+kH+LOe2vti8hHc7rG
	vFZBvA9EhS8bLI/hZk6F+P
X-Gm-Gg: AYBFou2YWrOky23EtAs51NantLrmBlKq/MmEDSSvG/d/3o/GuVlvKcIft8CvUGNWJ3c
	8kFgIWZ1pEV8IGnoxLVarL0HZIl6vTTGNKN4EXguz/Y+uQjYxpROU+tXmVRsIq4xBOMEtrBZWZT
	5EPzhQpHGFkFmtpp1bXizRh/K0X0ClGVyaHWtHo1SglWupvsp6thITyWxGD9kdMecFHq0/a0TOl
	7Jino5SCUKOy+UgLiuQWYcwsGpmaSUqBEV7O509jkwY+70mdM9bEe3y5xqodks7jahYhBiQU2G5
	HqaO4qLYO7wG65b+e26/nGOhT8LXfDPckXPvHHgETGCNRooKExJGD90C2yDgBzeuaOJeBQT+RuF
	3yzloZZ1Qv6GzlTljRWF3X620TEMukrzacA5m7vKGtK2M27fq+TcHbGtVZL0JmMes+mtKvjBoiS
	BcHUH1bBTE/WddthlZIdoL9Wqu/JpL/XbBRiNiPcEHrwFHw3D7
X-Received: by 2002:a05:6402:e8d:b0:6b4:20bc:f97 with SMTP id 4fb4d7f45d1cf-6b442fbfbd7mr187773a12.9.1792782637712;
        Fri, 23 Oct 2026 12:10:37 -0700 (PDT)
X-Received: by 2002:a05:6402:e8d:b0:6b4:20bc:f97 with SMTP id 4fb4d7f45d1cf-6b442fbfbd7mr187741a12.9.1792782637324;
        Fri, 23 Oct 2026 12:10:37 -0700 (PDT)
Received: from 2a00-12d0-b0ea-16f0-4563-1995-c8d4-892f.ip.tng.de (2a00-12d0-b0ea-16f0-4563-1995-c8d4-892f.ip.tng.de. [2a00:12d0:b0ea:16f0:4563:1995:c8d4:892f])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4420f9211sm178105a12.15.2026.10.23.12.10.34
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:10:35 -0700 (PDT)
Message-ID: <39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com>
Subject: libtracefs 1.8.4 has failing tests on Ubuntu
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Date: Fri, 23 Oct 2026 21:10:33 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

in Ubuntu we run the tests once against the installed library and once
with valgrind. The valgrind tests were failing in our patched 1.8.3
version. So I upgraded to 1.8.4 and now both tests are failing:

trace-utest:

  Test: Follow events clear ...FAILED
    1. tracefs-utest.c:1747 - fdata.missed_hit > 0

trace-utest-valgrind:

414s Test: trace cpu pipe ...missed events -1
419s missed events 796093548
419s =3D=3D6341=3D=3D Invalid read of size 8
419s =3D=3D6341=3D=3D at 0x48A5F34: ??? (in /usr/lib/x86_64-linux-gnu/libtr=
aceevent.so.1.9.0)
419s =3D=3D6341=3D=3D by 0x48A9177: kbuffer_load_subbuffer (in /usr/lib/x86=
_64-linux-gnu/libtraceevent.so.1.9.0)
419s =3D=3D6341=3D=3D by 0x400D82C: read_trace_cpu_file (tracefs-utest.c:20=
15)
419s =3D=3D6341=3D=3D by 0x400DAEB: test_cpu_pipe (tracefs-utest.c:2080)
419s =3D=3D6341=3D=3D by 0x400DBE7: test_instance_trace_cpu_pipe (tracefs-u=
test.c:2096)
419s =3D=3D6341=3D=3D by 0x400DC3D: test_trace_cpu_pipe (tracefs-utest.c:21=
05)
419s =3D=3D6341=3D=3D by 0x48BF94C: ??? (in /usr/lib/x86_64-linux-gnu/libcu=
nit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x48BFC77: ??? (in /usr/lib/x86_64-linux-gnu/libcu=
nit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x48C0C0F: CU_run_all_tests (in /usr/lib/x86_64-li=
nux-gnu/libcunit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x4006D9B: main (trace-utest.c:81)
419s =3D=3D6341=3D=3D Address 0x8676a90 is 0 bytes after a block of size 4,=
096 alloc'd
419s =3D=3D6341=3D=3D at 0x4887E43: calloc (vg_replace_malloc.c:1616)
419s =3D=3D6341=3D=3D by 0x400A629: setup_trace_cpu (tracefs-utest.c:1152)
419s =3D=3D6341=3D=3D by 0x400DB7A: test_instance_trace_cpu_pipe (tracefs-u=
test.c:2089)
419s =3D=3D6341=3D=3D by 0x400DC3D: test_trace_cpu_pipe (tracefs-utest.c:21=
05)
419s =3D=3D6341=3D=3D by 0x48BF94C: ??? (in /usr/lib/x86_64-linux-gnu/libcu=
nit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x48BFC77: ??? (in /usr/lib/x86_64-linux-gnu/libcu=
nit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x48C0C0F: CU_run_all_tests (in /usr/lib/x86_64-li=
nux-gnu/libcunit.so.1.0.1)
419s =3D=3D6341=3D=3D by 0x4006D9B: main (trace-utest.c:81)
419s =3D=3D6341=3D=3D
425s missed events -1
430s missed events 173403680
430s FAILED
430s 1. tracefs-utest.c:2082 - cnt =3D=3D expect
430s 2. tracefs-utest.c:2082 - cnt =3D=3D expect
430s 3. tracefs-utest.c:2082 - cnt =3D=3D expect
430s 4. tracefs-utest.c:2082 - cnt =3D=3D expect
[...]

The corresponding Ubuntu bug is https://launchpad.net/bugs/2172071 and
the full test log can be found on
https://autopkgtest.ubuntu.com/results/autopkgtest-tenacious/tenacious/amd6=
4/libt/libtracefs/20261022_134419_661b1@/log.gz
The failure is reproducible.

The Ubuntu package only carries this patch that should not have an
influence:
https://git.launchpad.net/ubuntu/+source/libtracefs/plain/debian/patches/ad=
d-find_debug_tracing_dir-to-tracefs-utest.patch

--=20
Benjamin Drung
Debian & Ubuntu Developer
