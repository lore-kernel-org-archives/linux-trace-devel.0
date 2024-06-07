Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2662315ECD6
	for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jun 2024 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776357; cv=none; b=uERXRy9aAbZWTwfML4AIBEMTnmr4AlddLaji+R1caVcBXaWxKZ4dhrzNXHLQ9RB2k3HlcI0mBp/m6v1L/q3moi5Ry0xpiB3G3BNErg6dFQdhabqeY2EIHrvSikMcds+jKsyQraytcmu5mxGxxCm6j2xNVKa7b5326tA16j+6VMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776357; c=relaxed/simple;
	bh=ehn0KWp5L8jylcpBV/LH61cY43bwOj2WxBYtNxlvzKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bRbGXnWSxTHydTEoWaPahYcjLU6peuGJkWvdALAWsWDHy3xvFIaMLNBmV7Tcyesf7SRVubbtfnDj2F+ZjQ/V8vV8SD8WHDbIcbKZwUGSB025NAxFsg27czM/qfR0Cy3xn3dkVEW5pJHZA4f0rc/zLq1X0mR+D29x7o8ad57yopM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMjh6TFd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMjh6TFd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717776354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jhVm2Si5GJ3JmoAQx8tNCo2M7FQb/WT/R9hMkWaI8KQ=;
	b=VMjh6TFdmYegdM3N1Q+7Mu5MOfVNeObdFcp++k0ioFtMLjKZ1u73hQoX+RRgR2ft+d1lFN
	A03OxcEZd1uc5aKSPRmNqjaWuuIkDllqinjpqu9IpkZSWJ/K8LtaPQawdJrMFxnPkgxOMJ
	lHS9wGHeplYdPw0nUGTums71XbP849o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-FrH9ajEbO2igkh9M--oJRw-1; Fri, 07 Jun 2024 12:05:48 -0400
X-MC-Unique: FrH9ajEbO2igkh9M--oJRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EA31101A52D;
	Fri,  7 Jun 2024 16:05:45 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by smtp.corp.redhat.com (Postfix) with SMTP id 9E49CC15BC3;
	Fri,  7 Jun 2024 16:05:43 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:05:42 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 0/4] libtraceevent: fix misc issues found by static analysis
Date: Fri,  7 Jun 2024 18:05:38 +0200
Message-ID: <20240607160542.46152-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

A few issues were found by running static analysers on the code
of trace-cmd with openscanhub[1].

[1] https://fedoraproject.org/wiki/OpenScanHub

Jerome Marchand (4):
  libtraceevent: close shared object in the error path of load_plugin()
  libtraceevent: prevent a memory leak in process_fields()
  libtraceevent: prevent a memory leak in tep_plugin_add_option()
  libtraceevent: don't return a pointer to a local variable
    get_field_str()

 src/event-parse.c  |  2 +-
 src/event-plugin.c | 10 ++++++----
 src/parse-filter.c |  3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.45.1

