Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C543254B4
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106652; cv=none; b=nY2Yy8kYqHCo3lAd2ZNm/3lnU7GhH708N/7pwMJne25Z3wfwbs88hI2UrShQamnUpjZY3rEmn0nkXBFKpuTVC1NyqwfMh+uEEf5xrKjfOnoQcqgSjDq5vltC++ATjIUltdY4QjSzuu5ZC1ktjDYgrQ4RuIhjs83r3mTYcufbVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106652; c=relaxed/simple;
	bh=5OAMBLXx91pla+RQcguQK0eVcLA7IXwQ3gHLhW6SJ50=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXb8af9ylW0cRUyDoRbymH3EAP0QPMJ/PoiclDXVnAerWazMzoAwf1o53f3hPB83pip65O8qHKlYyh3UhQbLo7cET99S0Z5WE4ScxStyGvKhHg6yNIdZihh4dKMG/QWvMBXbqQs5BNEVZ7TSDCzC4BYDOzW1ESOWBqTLxLkiF2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63A70564E4;
	Tue, 30 Dec 2025 14:57:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id CA39E20025;
	Tue, 30 Dec 2025 14:57:26 +0000 (UTC)
Date: Tue, 30 Dec 2025 09:57:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>, Metin Kaya <metin.kaya@arm.com>
Subject: Re: i586: make test: event-parse.c:5643:(.text+0x16e6): undefined
 reference to `_tep_local___stack_chk_fail_local'
Message-ID: <20251230095734.46a5f2a4@gandalf.local.home>
In-Reply-To: <20251230095143.072ba657@gandalf.local.home>
References: <d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org>
	<20251230095143.072ba657@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: skth5b5ryud7n4mkki5bai3m8whza8fu
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: CA39E20025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+2dTwoVNoNGBH6Cc7HOnB56sigRljk/kQ=
X-HE-Tag: 1767106646-29453
X-HE-Meta: U2FsdGVkX19G1dEbwDSuLEV4h41O29kdW64+mhsGJ8w2eUlX3etGeV4d6Er3906Hhw5qLODxGM9JgRdtOkgbDtfSS6aeAUdaF4u2a5RRRyggcro5gZeu4C3qNgfDAHk1IRyR0VbegKxE/ezWYKOm069VAW5GVFnDOuM5B13iAhvtp7QKu5TXtWOVu2sV9x5OrcYx5c+1b+6BGyyAjpPy3Nj/Hy8OC+KXdgojHcuG8X1KpfdZ3IYDAkMkEcYb1iITr9xgcZSOmV5ztHRgkOAsn6PY6OBpSaysXl0hqYPxG8glis2ItT3wkrfMiVyxh7jq0aepn2lg5KJui4Yqt6CIF0bMMJRV3Px3uf0W1K037Uy74ogrzcm2AzHeaNpYyIw+

On Tue, 30 Dec 2025 09:51:43 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > [00:00:30] ( gcc /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-ute=
st.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/traceevent-utest.o /usr/s=
rc/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a -rdynamic -o /usr/src/=
RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest   -ldl -lcunit -ldl /usr/sr=
c/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a)
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent=
.a(event-parse.o): in function `print_ip6c_addr':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:564=
3:(.text+0x16e6): undefined reference to `_tep_local___stack_chk_fail_local=
' =20
>=20
> This looks like the code that is used to hide internal global functions in
> the static library. I'll have to set up a x86_32 VM and see if I can
> reproduce it.

I forgot I had a 32bit VM available. I tried it there and it gave me:

~# make test
  DESCEND            src libtraceevent.a
  DESCEND            utest test
  COMPILE FPIC       trace-utest.o
  COMPILE FPIC       traceevent-utest.o
traceevent-utest.c: In function =E2=80=98test_btf_read=E2=80=99:
traceevent-utest.c:385:33: warning: unsigned conversion from =E2=80=98long =
long int=E2=80=99 to =E2=80=98long unsigned int=E2=80=99 changes value from=
 =E2=80=98140730998977488=E2=80=99 to =E2=80=982100556752=E2=80=99 [-Woverf=
low]
  385 |         unsigned long args[] =3D {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
      |                                 ^~~~~~~~~~~~~~
  BUILD              trace-utest
/usr/bin/ld: /work/git/libtraceevent.git/lib/libtraceevent.a(event-parse.o)=
: in function `consolidate_op_arg':
/work/git/libtraceevent.git/src/event-parse.c:2302: undefined reference to =
`_tep_local___udivdi3'
/usr/bin/ld: /work/git/libtraceevent.git/src/event-parse.c:2305: undefined =
reference to `_tep_local___umoddi3'
/usr/bin/ld: /work/git/libtraceevent.git/lib/libtraceevent.a(event-parse.o)=
: in function `eval_num_arg':
/work/git/libtraceevent.git/src/event-parse.c:4561: undefined reference to =
`_tep_local___udivdi3'
/usr/bin/ld: /work/git/libtraceevent.git/src/event-parse.c:4564: undefined =
reference to `_tep_local___umoddi3'
/usr/bin/ld: /work/git/libtraceevent.git/lib/libtraceevent.a(event-parse.o)=
: in function `print_event_time':
/work/git/libtraceevent.git/src/event-parse.c:7168: undefined reference to =
`_tep_local___udivdi3'
/usr/bin/ld: /work/git/libtraceevent.git/src/event-parse.c:7175: undefined =
reference to `_tep_local___umoddi3'
/usr/bin/ld: /work/git/libtraceevent.git/src/event-parse.c:7175: undefined =
reference to `_tep_local___udivdi3'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:22: /work/git/libtraceevent.git/utest/trace-utest] E=
rror 1
make: *** [Makefile:258: test] Error 2

I have a pretty good idea what the issue is.

Thanks for reporting it.

-- Steve
