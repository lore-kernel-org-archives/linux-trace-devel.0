Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AA1FCF7C
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Oct 2025 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328000; cv=none; b=D9zL3Zg4kiezxOGL6ZkU058jpaEWgF8/m+91YjnvPMlCa7nHpeimvXkft6Try2Lcy45Sxvx+kxsEfmXqbu4wUpLwPvV1OCSnhRd4aKNDhooR4aL6UJoFZINLrYe7wYryvCTZsPlwtjJQIsImd2mxVho5o0OA280cKqVi4brx2TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328000; c=relaxed/simple;
	bh=UEIXgBs4I+u8cRCVkdPynPLJf3XtZFLHtQg9Wgz8KUk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kB7pHtTxAJ1eWEAshdLmx+x0WrfCVOGTtVAqlKWmN9Tb2+65PQi7YfpB4k6eSN/qpU5RUS6BFZnpHWPdFxeb7SqkAWfb5QgPh13Sgvudv0WVlzx7OsUFLE3yeFIrP3pkSeE6ve1iWTtz1+qK4kQ9M3rUA96uJWu2g8ChqlEtjAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f0ZemYRi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0ZemYRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761327997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=c92Qogmu+bWUKj/lvS7FLVnFPsCe/u8Mlns3BvXHLo4=;
	b=f0ZemYRibUFmuDLxibWzS0J8phXcoo+WzipXWtANP0wX0a7PcKHH2oP7QYShf7vQvBBGza
	AZsOm9/Ll9RdfWDcRENdoB6E1Sqf1uCLOTitInDUJW8zKaDqfgiR2I7L9cECT5CgmXVBZ3
	/HWdhb7X6L5K+OS7CUkCZRCeiN5OA1A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-FHOVRDWlNHy7gb9yjpl8pg-1; Fri,
 24 Oct 2025 13:46:36 -0400
X-MC-Unique: FHOVRDWlNHy7gb9yjpl8pg-1
X-Mimecast-MFC-AGG-ID: FHOVRDWlNHy7gb9yjpl8pg_1761327995
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 547891808985;
	Fri, 24 Oct 2025 17:46:35 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF03319540EB;
	Fri, 24 Oct 2025 17:46:34 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 65D79400DFB07; Fri, 24 Oct 2025 14:43:37 -0300 (-03)
Date: Fri, 24 Oct 2025 14:43:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] tracecmd: --poll option is not passed down to guest
Message-ID: <aPu6yVSp0BtyNXc2@tpad>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


commit e7ffcbda9d62855ec30dc36ef5bebcb669321073 added the
--poll option to avoid waking up the trace buffer reader
from an isolated CPU:

    trace-cmd: Add option to poll trace buffers

    Waiting for data to be available on the trace ring-buffers may trigger
    IPIs. This might generate unacceptable trace noise when debugging low
    latency or real time systems. So introduce the poll option. When
    enabled, it forces trace-cmd to use O_NONBLOCK. The drawback to using it
    is that traces will be extracted by busy waiting, which will
    unnecessarily hog the CPUs, so only use when really needed.

    Link: https://lore.kernel.org/linux-trace-devel/20210602090803.12233-1-nsaenzju@redhat.com

    Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
    Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

However the --poll option is not passed down to the guest, which can cause
the wakeup (and associated latency) in the guest:

84221.535329: kvm_entry:             vcpu 1 rip 0xfff0
84221.535341: write_msr:            6e0, value 97374f0241f8
84221.535343: sched_switch:         cyclictest:6563 [4] S ==> swapper/1:0 [120]
84221.535343: ipi_send_cpu:         cpu=1 callsite=irq_work_queue+0x2f callback=rb_wake_up_waiters+0x0
84221.535344: write_msr:            83f, value f6
84221.535345: irq_work_entry:       vector=246

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>


diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4e1157c9..ac42d428 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6220,9 +6220,16 @@ static void add_arg(struct buffer_instance *instance,
 {
 	char *ptr, *arg;
 	int i, ret;
+	int long_opt;
+
+	long_opt = 0;
+	for (i = 0; long_options[i].name; i++) {
+		if (long_options[i].val == c)
+			long_opt = 1;
+	}
 
 	/* Short or long arg */
-	if (!(c & 0x80)) {
+	if (long_opt == 0) {
 		ptr = strchr(opts, c);
 		if (!ptr)
 			return; /* Not found? */

