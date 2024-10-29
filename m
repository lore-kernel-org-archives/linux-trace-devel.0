Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173261DD88E
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188891; cv=none; b=jtlwNqv3Yan2D7W15HPscNLNnza9y5kNZrxIamwVU2C34Km/VgneWqq699h9sOl8gejUCDnoYG6avqC32xu5ci+ofXceAihXt3bNSZa323KbjNH7aIy4nn7F0lED77DQpgfiH/bBdGvyXuO0JYmsEWQF1w9DnSf0bUCxrUEC1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188891; c=relaxed/simple;
	bh=K7RaHLF5qxu+8Qw8+InTfHonQvSU8eOMXAbSmfxvCfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So3aQhD6yCdJm/tlzoXbF9FyWkAK9aeL/Vu13HA4s5zqCOxaHuhoDEcS5bBm5xHqVYINlkTIc0jWGqnr+wNgg1ko8jsEaSYswVdII/wEqy/vFCZzkJki1pUqKjpb3IUiNBcZPUuTw3GlsgeTAQDPeMf/dxMbIChe9TeNCTswv9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UP9VeYd2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UP9VeYd2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHcxWMp6mHTBzM9qyOjHvVrBHeZoBNlLhQe/6Hnwj0M=;
	b=UP9VeYd2aiYIDsea3bZM3+unf/tejFlbKgUfEV7Ps4iJps4i/2Gpbor3m5SV9SssCXAslq
	MtF41JHOAzx+txqMiTRtbzSWUD/NO2Zs+NsXfRaiSf6DObZYXE03Kkh7TA9kQex6wkXI+s
	ikH8yUlLAScC1pNu0sd8tykQ1V3Ctkc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-z82UKB1RPLaV9YGa_Hg9sA-1; Tue,
 29 Oct 2024 04:01:22 -0400
X-MC-Unique: z82UKB1RPLaV9YGa_Hg9sA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1095319560B7;
	Tue, 29 Oct 2024 08:01:21 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E277A19560A2;
	Tue, 29 Oct 2024 08:01:18 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:17 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 0/8 v2] trace-cmd: fix misc issues found by static analysis
Date: Tue, 29 Oct 2024 09:01:09 +0100
Message-ID: <20241029080117.625177-1-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

A number of issues were found by running static analysers on the code
of trace-cmd with openscanhub[1]. Mostly ressource leak, but some are
more serious like memory corruption.

[1] https://fedoraproject.org/wiki/OpenScanHub

Jerome Marchand (8):
  trace-cmd lib: Prevent a memory leak in handle_options()
  trace-cmd record: Prevent a memory leak in show_error()
  trace-cmd lib: Check the return value of do_lseek() in
    trace_get_options()
  trace-cmd dump: Prevent buffer overrun in dump_clock()
  trace-cmd record: Prevent memory leak in setup_network()
  trace-cmd lib: Prevent memory leak in tracecmd_create_event_hook()
  trace-cmd mem: Prevent a memory leak in trace_mem()
  trace-cmd record: Check the length of the protocol version received

 lib/trace-cmd/trace-hooks.c  | 2 ++
 lib/trace-cmd/trace-input.c  | 7 +++----
 lib/trace-cmd/trace-output.c | 2 ++
 tracecmd/trace-dump.c        | 2 +-
 tracecmd/trace-mem.c         | 6 ++----
 tracecmd/trace-record.c      | 5 ++++-
 6 files changed, 14 insertions(+), 10 deletions(-)

-- 
2.47.0

