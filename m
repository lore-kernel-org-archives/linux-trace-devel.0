Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9576207A2B
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729086349; cv=none; b=RQ5SWbv4V9H0U7iArCiSWxnSMDSgf0h3nGKhlEbxnIqsibiF4ZKZGOemTXwVRz/FyThBG0xLxVwKCbN3tW/Cq+xyAnBnaElkgTxQPuraNh4vVFJPq+9SrLABqNodyzLzYjYEGxqJ93/lHrMAympHb7eskCj0c5blY3jLTx4Amog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729086349; c=relaxed/simple;
	bh=tJl0aHBsu2ruo04xkRXm5bdaInEagx7TVSVBZP0UKnc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnN5vJXtp90V1WEOKhbWaG6S7Fs4f/GcugqrEdNXFNj4zuUd3PeUGX5SsosxzYoreldQujbfFo+nQfPfB+4DXB6Zt2mltwGryO9ONE0pqs48x+o4VHbm0fVsnDhuFCsrTDtyA4J0D9xSNWtaWFmAMLtXwFJk+jajC966U6FFjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC048C4CEC7;
	Wed, 16 Oct 2024 13:45:48 +0000 (UTC)
Date: Wed, 16 Oct 2024 09:46:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Have tracefs_dynevent_get_all() find
 kprobes and uprobes properly
Message-ID: <20241016094609.42deb093@gandalf.local.home>
In-Reply-To: <6dbeb80b-03b2-4060-8737-3a08432590c6@arm.com>
References: <20241015151117.5562bd41@gandalf.local.home>
	<3c199734-5ece-4895-92b5-a15cc8b1edf1@arm.com>
	<6dbeb80b-03b2-4060-8737-3a08432590c6@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2024 09:33:00 +0100
Metin Kaya <metin.kaya@arm.com> wrote:


> >=20
> > I could successfully apply the patch on 4cbebed79b1f ("libtracefs:=20
> > Documentation: Add missing documentation to meson.build").
> > The unit tests at [1] passes with this patch.
> >=20
> > Just for the records, there are some unit test failures in libtracefs=20
> > (they were there even before the patch):
> >=20
> > $ sudo ./utest/trace-utest
> >  =C2=A0=C2=A0=C2=A0=C2=A0 CUnit - A unit testing framework for C - Vers=
ion 2.1-3
> >  =C2=A0=C2=A0=C2=A0=C2=A0 http://cunit.sourceforge.net/
> >=20
> > Memory mapped buffers not supported
> >=20
> > Suite: tracefs library
> >  =C2=A0 Test: Test tracefs/debugfs mounting ...FAILED
> >  =C2=A0=C2=A0=C2=A0 1. tracefs-utest.c:1806=C2=A0 - ret =3D=3D 0

Note, if you have anything in the /sys/kernel/tracing directory (including
gdb instances of trace-cmd), it will fail to unmount. I tripped over this
too.

> >  =C2=A0 Test: trace cpu read ...passed
> >  =C2=A0 Test: trace cpu read_buf_percent ...passed
> >  =C2=A0 Test: trace cpu pipe ...passed
> >  =C2=A0 Test: trace pid events filter ...passed
> >  =C2=A0 Test: trace pid function filter ...passed
> >  =C2=A0 Test: trace sql ...passed
> >  =C2=A0 Test: trace sql trace onmax ...passed
> >  =C2=A0 Test: trace sql trace onchange ...passed
> >  =C2=A0 Test: trace sql snapshot onmax ...passed
> >  =C2=A0 Test: trace sql snapshot onchange ...passed
> >  =C2=A0 Test: trace sql save onmax ...passed
> >  =C2=A0 Test: trace sql save onchange ...passed
> >  =C2=A0 Test: trace sql trace and snapshot onmax ...passed
> >  =C2=A0 Test: trace sql trace and snapshot onchange ...passed
> >  =C2=A0 Test: tracing file / directory APIs ...passed
> >  =C2=A0 Test: instance file / directory APIs ...passed
> >  =C2=A0 Test: instance file descriptor ...passed
> >  =C2=A0 Test: instance reset ...passed
> >  =C2=A0 Test: systems and events APIs ...passed
> >  =C2=A0 Test: tracefs_iterate_snapshot_events API ...passed
> >  =C2=A0 Test: tracefs_iterate_raw_events API ...FAILED
> >  =C2=A0=C2=A0=C2=A0 1. tracefs-utest.c:235=C2=A0 - ret =3D=3D sizeof(st=
ruct test_sample)
> >  =C2=A0=C2=A0=C2=A0 2. tracefs-utest.c:235=C2=A0 - ret =3D=3D sizeof(st=
ruct test_sample)

Did you do a trace-cmd reset before running the tests?

> >  =C2=A0 Test: Follow events ...passed
> >  =C2=A0 Test: Follow events clear ...passed
> >  =C2=A0 Test: tracefs_tracers API ...passed
> >  =C2=A0 Test: tracefs_local events API ...passed
> >  =C2=A0 Test: tracefs_instances_walk API ...passed
> >  =C2=A0 Test: tracefs_get_clock API ...passed
> >  =C2=A0 Test: tracing on / off ...passed
> >  =C2=A0 Test: tracing options ...passed
> >  =C2=A0 Test: custom system directory ...passed
> >  =C2=A0 Test: ftrace marker ...passed
> >  =C2=A0 Test: kprobes ...passed
> >  =C2=A0 Test: synthetic events ...passed
> >  =C2=A0 Test: eprobes ...passed
> >  =C2=A0 Test: uprobes ...FAILED
> >  =C2=A0=C2=A0=C2=A0 1. tracefs-utest.c:2222=C2=A0 - ret =3D=3D 0
> >  =C2=A0=C2=A0=C2=A0 2. tracefs-utest.c:2222=C2=A0 - ret =3D=3D 0

Did you have left over uprobes?

> >=20
> > Run Summary:=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=A0 Total=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Ran=C2=A0=C2=A0 Passed Failed Inactive
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 suites=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 n/a=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 tests=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 36=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 36=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 asserts 30341119 30341119 30341114=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 n/a
> >=20
> > Elapsed time =3D=C2=A0 124.937 seconds
> >=20
> > With that,
> >=20
> > Reviewed-by: Metin Kaya <metin.kaya@arm.com>
> >=20
> >=20
> > Thanks a lot for fixing it promptly!
> >=20
> > [1]=20
> > https://lore.kernel.org/all/20241015140840.4183007-1-metin.kaya@arm.com/
> >=20
> >  =20
>=20
> Sorry, I need to revoke my Reviewed-by. Because, "trace-cmd reset"=20
> cannot destroy uretprobes after this patch.
>=20
> # cd /sys/kernel/tracing/
> /sys/kernel/tracing # cat uprobe_events
> /sys/kernel/tracing # echo 'r /bin/bash:0x4245c0' > uprobe_events
> /sys/kernel/tracing # cat uprobe_events
> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
> /sys/kernel/tracing # trace-cmd reset
> /sys/kernel/tracing # cat uprobe_events
> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
>=20
> OTOH, "trace-cmd reset" is able to destroy uretprobes if there is also a=
=20
> kprobe in addition to a uretprobe:

Oops, I know why. I had a bug in the code that collects all the probes and
looks at different files. It assumed that if the return of
tracefs_instance_file_read() returns NULL from kprobe_events, it is an
error. But that function also returns NULL if the file is empty. I changed
the code from:

	content =3D tracefs_instance_file_read(NULL, desc->file, NULL);
	if (!content)
		return -1;

to:

	if (!tracefs_file_exists(NULL, desc->file))
		return -1;

	content =3D tracefs_instance_file_read(NULL, desc->file, NULL);
	/* File exists, but may be empty */
	if (!content)
		return 0;

I'll send out a v2. Thanks for testing.

I'll also add more tests to the libtracefs utest to check for this too.

-- Steve


>=20
> /sys/kernel/tracing # cat dynamic_events
> /sys/kernel/tracing # cat uprobe_events
> /sys/kernel/tracing # echo 'p do_sys_open' > kprobe_events
> /sys/kernel/tracing # echo 'r /bin/bash:0x4245c0' > uprobe_events
> /sys/kernel/tracing # cat dynamic_events
> p:kprobes/p_do_sys_open_0 do_sys_open
> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
> /sys/kernel/tracing # cat uprobe_events
> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
> /sys/kernel/tracing # trace-cmd reset
> /sys/kernel/tracing # cat dynamic_events
> /sys/kernel/tracing # cat uprobe_events
> /sys/kernel/tracing #

