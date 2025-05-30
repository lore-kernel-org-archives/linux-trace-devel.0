Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA61E7C27;
	Fri, 30 May 2025 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748629632; cv=none; b=Q+MATNo2P25Ty94TeIT4+wriAwLjwWN0pDb7WGSEkGIaE8Z31w8Qpf1+iH0I3QWY7TTm7rbeC3CDKuGuzRNte5wgo/9zuZ81oQpHNgOAGJId/xA3W2k+gDGM9IkjmYS95d2gWq53fACwXeMHnEB8Rws3ggqsL+Kmh+uuR5ejXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748629632; c=relaxed/simple;
	bh=HJrIVdxXH0QN2+7IG91kwMY8uwI6LygH+NfAvUPRByo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=t+O2USe3HghB4m0gFNTMb7cpzaM47x1jXMpCbTxZUiqNTyq3Je19al1PO6bKNc8QkqXPNnEE3LttNHq4zc4WkokFyNaE7JEf1os2rE/aovMF4eG3OQhxi9FZ04DoCF1gYNoOoeFONtW167mpQU6aOQFoKsOGqyJY7yMZrF7F49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC067C4CEE9;
	Fri, 30 May 2025 18:27:09 +0000 (UTC)
Date: Fri, 30 May 2025 14:28:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "linux-trace-users@vger.kernel.org" <linux-trace-users@vger.kernel.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Alexander Aring <aahringo@redhat.com>, Douglas Raillard
 <douglas.raillard@arm.com>, Ian Rogers <irogers@google.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 primiano@google.com, Joel Fernandes <agnel.joel@gmail.com>, Beau Belgrave
 <beaub@linux.microsoft.com>, Jiri Olsa <jolsa@kernel.org>, Indu Bhagat
 <indu.bhagat@oracle.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Subject: Fw: Tracing Summit 2025 - Call for Proposals  reminder
Message-ID: <20250530142814.67ca7497@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


The Tracing Summit is happening in September. If you have anything you
would like to present, the CFP ends June 13th.

Please forward this to anyone you may know that might want to present as we=
ll.

-- Steve


Begin forwarded message:

Date: Fri, 30 May 2025 18:00:12 +0000
From: Tracing Summit <info@tracingsummit.org>
To:   <rostedt@goodmis.org>
Subject: Tracing Summit 2025 - Call for Proposals  reminder


Hello all! =C2=A0

This is a reminder that the Call for Proposals for the Tracing Summit 2025 =
[0] will close soon (June 13). Please make sure to submit a proposal [1] in=
 time if you want to present.


- Event dates: Tuesday, September 2, 2025 - Wednesday, September 3, 2025
- Location: Montr=C3=A9al, Qu=C3=A9bec, Canada and virtually
- Registration cost
    - In person & Virtual: Free
- Call for proposals link: [1]

 =C2=A0
Important dates:
- Call for proposals close: Friday, June 13, 2025 at 11:59PM EDT
- Call for proposals notifications: Friday, June 20, 2025
- Schedule announcement: Tuesday, June 25, 2025
- Event dates: Tuesday, September 2, 2025 - Wednesday, September 3, 2025

You can follow this link [2] to register to attend (free of charge). You ca=
n subscribe to the mailing list to get the latest information on the event:=
 [3]
 =C2=A0

The 2025 Tracing Summit is a two-day, single-track conference on the topic =
of tracing. The event focuses on software and hardware tracing, gathering d=
evelopers and end-users of tracing and trace analysis tools. The main goal =
of the Tracing Summit is to provide space for discussion between people of =
the various areas that benefit from tracing, namely parallel, distributed a=
nd/or real-time systems, as well as kernel development.

We are welcoming 30 minute presentations from both end users and developers=
, on topics covering, but not limited to:

- Investigation workflow of real-time, latency, and throughput issues,
- Trace collection and extraction,
- Trace filtering,
- Trace aggregation,
- Trace formats,
- Tracing multi-core systems,
- Trace abstraction,
- Trace modeling,
- Automated trace analysis (e.g. dependency analysis),
- Tracing large clusters and distributed systems,
- Hardware-level tracing (e.g. DSP, GPU, bare-metal),
- Trace visualization,
- Interaction between debugging and tracing,
- Tracing remote control,
- Analysis of large trace datasets,
- Cloud trace collection and analysis,
- Integration between trace tools,
- Live tracing & monitoring,
- Dynamic instrumentation,
- Programmable tracing (e.g. eBPF).

Talks can cover recently available technologies, ongoing work, and yet non-=
existing technologies (that are compelling to end-users). Talks covering in=
teresting or challenging tracing use cases are also welcome as they can rev=
eal future directions or tooling needs.

Please understand that this open forum is not the proper place to present s=
ales or marketing pitches, nor technologies which are prevented from being =
freely used in open source.

Please send any questions about this conference to <info@tracingsummit.org>.

This event is organized by EfficiOS [4] on behalf of the Linux Foundation D=
iagnostic and Monitoring Workgroup [5].


[0]: https://tracingsummit.org
[1]: https://cfp.tracingsummit.org/ts2025/cfp
[2]: https://pretix.eu/diamon/ts2025/
[3]: https://eepurl.com/goakfv
[4]: https://www.efficios.com/
[5]: https://diamon.org/


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Copyright =C2=A9 2025 EfficiOS, All rights reserved.
You are receiving this email because you showed interest about Tracing Summ=
it.

Unsubscribe rostedt@goodmis.org from this list:
https://efficios.us18.list-manage.com/unsubscribe?u=3D2d3e5eb6de64590a1f22c=
c9d3&id=3D4e5381866f&t=3Db&e=3D8769f0bbf1&c=3D8c90866c32
