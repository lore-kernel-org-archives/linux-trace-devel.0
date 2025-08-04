Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D7625A350
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311526; cv=none; b=mT59X4mwVHjpJ/fJ04rbf+JjosYMYEg0aPw6sqqzUa8oilqJ9atzawvq2yqUAVsKDBt9mph/Z6sfyOhAlEgNjBuH06LH9R3KBwKKFEJexvR8JxU6t3rJ0mOR2BbLMZNR4Lx82/ea/ZJjKjOFrzNqvVlX/Dk7TDD6d4qf2+ZyFCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311526; c=relaxed/simple;
	bh=U0dxkDMZNOEsuG7UyCy4FrRE4aGC5kE3qIxqCuZMJac=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r99c8PAhuj1+8EL7gyRKr+RBPA+dS1uVABsJY8awxqzU6x9EZYenH0UdrmT+UbgsZ3ulYMBr8PUcCQfcTQjNtICDlxgaBLiPU4RiM59hviUtMyKdc4JhbEN37K/x4Lq9iuyK+8R8PFW1tGmldaAXM6tPR89g0kkaaaF/u4WkPzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B132911404D;
	Mon,  4 Aug 2025 12:45:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id BED092F;
	Mon,  4 Aug 2025 12:45:15 +0000 (UTC)
Date: Mon, 4 Aug 2025 08:45:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 0/5] trace-cmd: Use BTF to parse function arguments
Message-ID: <20250804084543.61c4d6c7@gandalf.local.home>
In-Reply-To: <6457bff9-9485-4d2d-82a5-ae436932000a@arm.com>
References: <20250731202238.1654368-1-rostedt@goodmis.org>
	<6457bff9-9485-4d2d-82a5-ae436932000a@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xxzk5b94mjgmxj4wtsia57u85x5j435x
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: BED092F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19IaAt250vfMIJ6mErQrh/Mo8lrL4feqrg=
X-HE-Tag: 1754311515-658182
X-HE-Meta: U2FsdGVkX18ySoti+2n0DpzbKE3dG34LXto3cfIo0vZmGwWuFvCqpull7ZDAJK4EOZLAkHX5DnRCvETCnPFC/jfgp/Eqo5N37l8+h10cDgINchdLnVFdoqYyQpYLBAM/bdFkklIghvf4DyJBZnSIPghaAwsWLU+KkaZK91120dLwqVilxsBVUVbV1IhLblSoAqpvlTB7SyO2R10Kh2RSYyNdZDx8kS6tLpXZM7tD9IOa80inYrpM8d1dfm7LDAIwdezzAgUASy1yPGBKkTvkaFZY9cfRIfpfWH2VSHHN0MfsO3tsYRTUvRjlDAOzdhXBsKKoQV4l0q+nqDxW1A0kkRJD7dJomaHgqwwA2wfy/kRg9a1Di6tt1Q3PMnjWBbpwvj1HBv4p39lG9M4NB1zJRffjdScj0r8zdvRY1b/PZ54+2HxwD8dvd7pgFvql2WXY

On Mon, 4 Aug 2025 13:36:26 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> On 31-07-2025 21:20, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > If function tracer is recorded with func-args option set, or the
> > function_graph tracer is recorded with the funcgraph-args option set, then
> > record the BTF file in a new BTF_FILE section in the trace.dat file.  
> 
> Would it be possible to also add an explicit CLI flag to collect the BTF blob ?

Sure, that shouldn't be to hard. We could add --btf /path/to/file  for both
the record and the report.

-- Steve
