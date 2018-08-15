Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41594 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbeHOSNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 14:13:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id z8-v6so645112pgu.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Aug 2018 08:21:18 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [GIT PULL 00/35] perf/core improvements and fixes
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20180815150611.32080-1-acme@kernel.org>
Date: Wed, 15 Aug 2018 08:21:15 -0700
Cc: Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Kapshuk <alexander.kapshuk@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Benno Evers <bevers@mesosphere.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@arm.com>,
        Krister Johansen <kjlx@templeofstupid.com>,
        linux-trace-devel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Wang Nan <wangnan0@huawei.com>, x86@kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BA2DD2BE-2EBB-415A-9171-8CC90F3E7F31@amacapital.net>
References: <20180815150611.32080-1-acme@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


> On Aug 15, 2018, at 8:05 AM, Arnaldo Carvalho de Melo <acme@kernel.org> wr=
ote:
>=20
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>=20
> Hi Ingo,
>=20
>    Please consider pulling, this is on top of
> perf-core-for-mingo-4.19-20180809, that is not yet in tip.
>=20
> Thanks,
>=20
> - Arnaldo
>=20
> Test results at the end of this message, as usual.
>=20
> The following changes since commit 6a9405b56c274024564f9014bba97b92c91b34d=
6:
>=20
>  perf map: Optimize maps__fixup_overlappings() (2018-08-08 15:56:00 -0300)=

>=20
> are available in the Git repository at:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-co=
re-for-mingo-4.19-20180815
>=20
> for you to fetch changes up to 6855dc41b24619c3d1de3dbd27dd0546b0e45272:
>=20
>  x86: Add entry trampolines to kcore

I don=E2=80=99t object per se, but once I finish rebasing and testing my ent=
ry trampoline removal code, this will probably have to go.=
