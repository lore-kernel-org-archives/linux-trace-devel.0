Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84B024A08
	for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2024 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729261046; cv=none; b=g+QJ78pkbdzxxazBT4CFp4hBP8wUQiYR9BEHpC6U0Wjyha+HqtrPm4IqSNH2AetkQUPnfYrn1dW2bkJ1wmd+YnoZjPaGVSj46Kr9HUp4JjF8j0LzmnpIzNtWWqWBlt9gY00WfJbfl5pDdJxYr8K5vUVsq/RUCf8ZRhnZoj9V2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729261046; c=relaxed/simple;
	bh=tA3P+Ch1IQdMtYUNTLCAgpyQiDXyz64VHWtILBwQhNU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JTVdEaKnaG1YhVle/MwTsVHx9BxB2H0iVKhB/Onqt/iwgRjgN8+NN2s/LChD2qJ1oPkQLkPOXrS4RsBVypCuMdBlNJswRRO49DkxS24oCly9g41YZ+hlkSfaCCZjnLzRtMXzE1VumStTECo8n2dw4e7WIQx9E1ax2gFlRUb5s/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A4C4CEC3;
	Fri, 18 Oct 2024 14:17:26 +0000 (UTC)
Date: Fri, 18 Oct 2024 10:17:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
Message-ID: <20241018101751.76f6886f@gandalf.local.home>
In-Reply-To: <6c67124d-a806-42d6-a2c5-a74cccb4fce3@arm.com>
References: <20241016123552.55efa78f@gandalf.local.home>
	<e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
	<20241017160108.4f99c917@gandalf.local.home>
	<6c67124d-a806-42d6-a2c5-a74cccb4fce3@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2024 10:13:11 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> On 17/10/2024 9:01 pm, Steven Rostedt wrote:
> > On Thu, 17 Oct 2024 09:38:35 +0100
> > Metin Kaya <metin.kaya@arm.com> wrote:
> >  =20
> >> I see one more failure in this section of unit tests:
> >>
> >>     Test: tracefs_iterate_snapshot_events API ...FAILED
> >>       1. tracefs-utest.c:235  - ret =3D=3D sizeof(struct test_sample)
> >>       2. tracefs-utest.c:235  - ret =3D=3D sizeof(struct test_sample)
> >>       3. tracefs-utest.c:235  - ret =3D=3D sizeof(struct test_sample)
> >> =20
> >=20
> > Does this occur without this patch? IOW, is this caused by this patch? =
=20
>=20
> I thought there were 2 "tracefs-utest.c:235  - ret =3D=3D sizeof(struct=20
> test_sample)" failures before this patch and this patch increased the=20
> number of failures by 1. However, this does not seem to be 100% correct.=
=20
> I sometimes see only 1 failure, but then there are 2-3 of them.
>=20
> I do trace-cmd reset && unmount before running the unit tests.

Yeah, this is probably something different.

>=20
> >  =20
> >> I did run trace-cmd reset and unmounted my tracefs before running the
> >> unit tests.
> >> Please feel free to ignore if something is weirdly wrong in my setup.
> >>
> >> Other than that -kind of existing- failure, the patch looks good to me
> >> (e.g., trace-cmd unit tests are working fine). =20
> >=20
> >=20
> > Can you add a printf("ret =3D %d\n", ret) to find out what "ret" is? =20
>=20
> Here is the output with printf's:
>=20
>    ...
>    Test: tracefs_iterate_snapshot_events API ...
> line=3D237 i=3D87 path=3Dn~_ cpu=3D55 value=3D2046397138 ret=3D-1
> FAILED
>      1. tracefs-utest.c:240  - ret =3D=3D sizeof(struct test_sample)
>    Test: tracefs_iterate_raw_events API ...
> line=3D237 i=3D1444 path=3D~_ cpu=3D50 value=3D1150454427 ret=3D-1
> FAILED
>      1. tracefs-utest.c:240  - ret =3D=3D sizeof(struct test_sample)
>    Test: Follow events ...passed
>    ...

Hmm, looking at the code, I think it should be using trace_marker_raw and
not trace_marker. Although I don't believe that will fix this, it is still
something that needs to be changed.

-	path =3D tracefs_instance_get_file(instance, "trace_marker");
+	path =3D tracefs_instance_get_file(instance, "trace_marker_raw");

As trace_marker expects strings but trace_marker_raw takes binary data, and
we are writing binary data here.

Could you also add a "perror()" when it fails. The ret=3D-1 means the write
failed, so it would be good to know why it failed.

>    Test: uprobes ...
> line=3D2229 ename=3Dutest_u=20
> address=3D/libtracefs/utest/trace-utest:0x00000000000003e8 event=3Dutest_=
u=20
> system=3Dutest format=3Darg1=3D$stack2 prefix=3Dp type=3D0x000004 ret=3D-1
>=20
> line=3D2229 ename=3Dutest_r=20
> address=3D/libtracefs/utest/trace-utest:0x00000000000003e8 event=3Dutest_=
r=20
> system=3Dutest format=3Darg1=3D$retval prefix=3Dr type=3D0x000008 ret=3D-1
> FAILED
>      1. tracefs-utest.c:2232  - ret =3D=3D 0
>      2. tracefs-utest.c:2232  - ret =3D=3D 0
>=20
>=20
> And this is the output with your "libtracefs utest: Fixes and new tests"=
=20
> patch series [1]:
>=20
>    Test: tracefs_iterate_raw_events API ...
> line=3D237 i=3D2532 path=3DDb cpu=3D0 value=3D1144606227 ret=3D-1
>=20
> line=3D237 i=3D1285 path=3D=D7=953b cpu=3D6 value=3D1157898007 ret=3D-1
> FAILED
>      1. tracefs-utest.c:240  - ret =3D=3D sizeof(struct test_sample)
>      2. tracefs-utest.c:240  - ret =3D=3D sizeof(struct test_sample)
>    Test: Follow events ...passed
>    Test: Follow events clear ...passed
>    Test: tracefs_tracers API ...passed
>    Test: tracefs_local events API ...passed
>    Test: tracefs_instances_walk API ...passed
>    Test: tracefs_get_clock API ...passed
>    Test: tracing on / off ...passed
>    Test: tracing options ...passed
>    Test: custom system directory ...passed
>    Test: ftrace marker ...passed
>    Test: kprobes ...passed
>    Test: synthetic events ...passed
>    Test: eprobes ...passed
>    Test: uprobes ...
> line=3D2249 ename=3Dutest_u=20
> address=3D/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x0000000000000=
3e8=20
> event=3Dutest_u system=3Dutest format=3Darg1=3D$stack2 prefix=3Dp type=3D=
0x000004 ret=3D-1
>=20
> line=3D2249 ename=3Dutest_r=20
> address=3D/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x0000000000000=
3e8=20
> event=3Dutest_r system=3Dutest format=3Darg1=3D$retval prefix=3Dr type=3D=
0x000008 ret=3D-1
> FAILED
>      1. tracefs-utest.c:2252  - ret =3D=3D 0
>      2. tracefs-utest.c:2252  - ret =3D=3D 0
>    Test: multi probe test ...
> line=3D2249 ename=3Dutest_u=20
> address=3D/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x0000000000000=
3e8=20
> event=3Dutest_u system=3Dutest format=3Darg1=3D$stack2 prefix=3Dp type=3D=
0x000004 ret=3D-1
>=20
> line=3D2249 ename=3Dutest_r=20
> address=3D/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x0000000000000=
3e8=20
> event=3Dutest_r system=3Dutest format=3Darg1=3D$retval prefix=3Dr type=3D=
0x000008 ret=3D-1
> FAILED
>      1. tracefs-utest.c:2252  - ret =3D=3D 0
>      2. tracefs-utest.c:2252  - ret =3D=3D 0

Can you tell me what is at line 2252 because I don't know what patches you
have applied, and 2252 in my code doesn't mean anything.

Thanks,

-- Steve
