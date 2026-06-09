Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E77643D518;
	Tue,  9 Jun 2026 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017381; cv=none; b=TcScRy8nbU/SfClbQAJwGRCGuorFoFiFNs5tz9Ov1iL/4bnTzlrYIZqen/6W9CU9UAo7h+xHvwXdbO+pN0BaghjUiLz5Ag9stcFaWZxT4wjsfY2TQEfPrdmJ/BhBN0PeVfu3AhVJOJznmIxMYM6LOCf3cgebKaOch2aytvAFw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017381; c=relaxed/simple;
	bh=jib5mn+3RmtqhFJwUiXYnhJHVpB5Laika14vNqpxqqA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AiMJui3CASKjW6mmZbCQFjbPgceKuCAH4Gd0XpBRc5jQQoE1+ypoJ/CpS5nuyS7HQFi7PEs3CS9hqa8fAOcbmpAlV/YuiAegmu6E14i4DLN/v4W340pOLc1jEu6KbntXxb8ldJ9BMPEQq2Z4FpIik7+iVqt5TDSJLngBDQeywOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rostedt.org; spf=pass smtp.mailfrom=rostedt.org; dkim=pass (2048-bit key) header.d=rostedt.org header.i=@rostedt.org header.b=xQzD4mo/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=R00GJ4A/; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rostedt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rostedt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rostedt.org header.i=@rostedt.org header.b="xQzD4mo/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="R00GJ4A/"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id A34EC1D000D2;
	Tue,  9 Jun 2026 11:02:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 09 Jun 2026 11:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rostedt.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1781017378; x=1781103778; bh=SY
	1z+Kbi3GWO3NeBX9/bHE6RV1hiB3oBcqoziDZyzdQ=; b=xQzD4mo/3cjNneehhE
	5gvIFwyKbh+QE/mGCe7OfNh35JaEu5bqv5OQZRH3hzv9hGxcrcv95hfyjZOG7zd7
	4axqnnmGxuudn4JadMCklVlgHb817133HTT6pG7c/n1jR04n4UMFTSIP/TWtx0/U
	K3Dh1zTrRwDC/b4sbGLZLGVVC+w2KdMZe4Rp35DrDjx5A9ZWqFE3X562EgFBDyTw
	nX3JAFZj7y6OTSsvyNyrqogdRTAWR6eHZhZXlQXtgOlA6E/eu363yugyfTdbtP3s
	EeSTfGQBmI/pJkg+Hj9zSajapVBycDgqQs7F/HrIPmW8A5cQDCd0mTit53u0MxEo
	AqZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1781017378; x=1781103778; bh=SY1z+Kbi3GWO3NeBX9/bHE6RV1hi
	B3oBcqoziDZyzdQ=; b=R00GJ4A/O716MptH7hdSBNrsHSiyk8BXeXos65ZgzMzV
	vkiGinylE4boqXcm06u2r/070UdzMCVeY5ib2zoP3vhmNFt3OCECmaeEq3pAPVTY
	srkE3S66RqKWfu5VbQM2T7LjYCA/dYInzzwSCtAAqQ7GhjS++SzhlEYi87nl8Ste
	yXdo3zvZshtHua/tL9Dx0chH3oDkQfNmKSSO27TsWGqfedMkwrpSojG0uoFKW750
	zk02Uok3kdm0xpz6dY0TNk3zLeg0Kvf9pYL+CxZZiZQImkAmt8ewbjPjg7pFQIf2
	nzQTyA+Ldg2RBhppUCAyTCjVEDr+iDgQd1oTsqObyg==
X-ME-Sender: <xms:Iisoas6dW9mIsAiYBOf17Q05HxwgzLIkN1f6CzR679RBMpdYkWKefQ>
    <xme:Iisoal37p_2rFvt0WSFA2XQDycUK-wRykRzISqQyP4teo46NKohxBxcIr1MPUCPr7
    ximpqGfkAus2fLlQyauhnV3U-hI9RCERw96Vi-hDe1DYIxkahl4IAc>
X-ME-Received: <xmr:IisoaiqevWH9tF8xUGbXZwZdsrzKF-wngOupup9NIjVfP3cGADMOoadc>
X-ME-Proxy-Cause: dmFkZTEsHgkI2cbii2IU0g921/ycC+qCa9oklhM6HUdqBif26TVKlHwG4xPTilvqCjC5eV
    I4vb09nj7zV5K0w/mnFMyvdKslQtLM6KPmYIcH4MVlQvn22tSognWCQYTl7WG7NC/7l8oW
    a/OoCDf31DlSPhkwJnfp642QwQkkINXHlg8MQ6NIJ3leDmZ4NLEcxJNYwUZmdgYQmlYnis
    eY1piOVwNkfiBSTlp1K4wVIb9zxF+QcdnlFiLtHVEzgyGq1AJHKuMI94usVgOJAhhTe/qR
    lDhusl89IpIiLTWOREkXN4BlL8MH88UlADZZZLPLesv5A1a4BW+6ITb0NnJr8xg3bdfsCi
    dGq7rIOb3jnCfEzttF+40EPY0t7o2PYp6kJd5mN/5s0Dbnhh/Pe3MkzHTsvYnrmI2jZ1Ey
    RYe89KRmT2qJDAprebS9/lqhPHHUGgZDTUuYEwvzhGQXPaut/B1+KqXSk5BXdRMyeexQex
    Si+1X5SymU/KqgladTYxwprO+UlqX4GwS5Fr+aXEsZ0KGKVA9cZvdpGsXCddNOEEewYTok
    W9dvGRlhPxzxdWVWqSnIlBiynBb3WT5mQoy9PJUyNylLhzVrT5DymkE9Bt8/SoeI10RXkE
    mnFuQ55b2CFe9psqPxbEAaqwm3f9SrvUCB/rZ8DR5Zx5yGbE2xwVlrRikB+Q
X-ME-Proxy: <xmx:IisoanlxcUl3QmW-lWH7v4We3iHYzj5xM1Pbp-VVCeG9Myck5YC0GQ>
    <xmx:IisoasRYu2yEd2lpXj_FQcuc_TJKmVPqkGZr6OOSs7bKzl8vAk4vkA>
    <xmx:IisoapAb64756GrVYQxT6tHeTGGg7MxqGZa8YReNxmCBDsdKvAC0AQ>
    <xmx:IisoasoQ_XdCixjbO5I7E5zuwz3so0j1y0c7wd_R1v5CfUv72mwoDw>
    <xmx:IisoamZJypIF51MZpWI_ZeUmLClTEl5qFej5akgcomLD0lzAbXvghfK9>
Feedback-ID: id06e481b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Jun 2026 11:02:56 -0400 (EDT)
Date: Tue, 9 Jun 2026 11:02:42 -0400
From: Steven Rostedt <steven@rostedt.org>
To: LKML <linux-kernel@vger.kernel.org>, "linux-trace-users@vger.kernel.org"
 <linux-trace-users@vger.kernel.org>, Linux trace kernel
 <linux-trace-kernel@vger.kernel.org>, Linux Trace Devel
 <linux-trace-devel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ian Rogers
 <irogers@google.com>, Dylan Hatch <dylanbhatch@google.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Jens Remus <jremus@linux.ibm.com>, Indu Bhagat
 <ibhagatgnu@gmail.com>, Beau Belgrave <beaub@linux.microsoft.com>, Tomas
 Glozar <tglozar@redhat.com>, Gabriele Monaco <gmonaco@redhat.com>
Subject: [ANNOUNCE/CFP] Tracing Microconference at Linux Plumbers
Message-ID: <20260609110242.467f37ce@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

The Tracing Microconference is accepting new topic proposals.

  https://lpc.events/event/20/contributions/2316/

All Linux kernel tracing related topics are appropriate to discuss. If
there's a Linux kernel tracing issue that you are having or a feature
you would like to see, please submit your problem statement at:

  https://lpc.events/event/20/abstracts/

Make sure to select "Tracing MC" in the "Track" pulldown.

Topics may include but not limited to;

 o  Stack tracing features
 o  Better lock statistic tracing
 o  Better system call tracepoint recording
 o  Updates to the persistent ring buffer
 o  More features for dynamic events
 o  Better integration between perf, ftrace and BPF
 o  Integration with BTF

The above is just ideas for topics, but is not an exhausted list. Feel
free to submit anything you think is relevant.

For what is expected for a microconference, please read the blog on
"The Ideal Microconference Topic Session":

  https://lpc.events/blog/current/index.php/2023/06/26/the-ideal-microconference-topic-session/

Note, those that submit topics before July 10th will become eligible to
pre-register for the conference.

The CFP itself closes on August 7th.

Looking forward to seeing you at Linux Plumbers in Prague!

-- Steve
