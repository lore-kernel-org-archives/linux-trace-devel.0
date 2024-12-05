Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746AA21A420
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409889; cv=none; b=Xf/KKWzONw4pN/2Fz0fmeSR8rwieEihf5XKOsMMCCxNJ2fnMveF9mUcT4x199gVxalgAtfhyRtwLNRleWt4Amn6gNwLcfgMVttvR33YNf2g1CYdCxsLhPpBuKTUSOLvoktXTYNhVM3I9XGyM8Vknca8+jOq6hFZUtPx0gSjh+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409889; c=relaxed/simple;
	bh=Nlc6BZsyuv2piiiZZjvfsYau+3NpA4yCTSmmta0diZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kdhc3BX1CzGi0Jccma+JTKP5Do5qdgcEe398xwFadai/AFTS/MA7gDG7axNCPfbLZ1MPfzbVCu4rPa3skdrtLvd/+2nVyu+VWlQTKlic8yskHBXOuXiF9zk/7ZShos7Vw3GbyY2zh5/+FeTtI7nwSsHvizVIb4aArawgoCr9lEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NFSObGu9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFSObGu9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hVY/JZnnKluZEgncGDazMqCosz8beoOrjct7rSDX45g=;
	b=NFSObGu9HAtIeWNB5Lj0+L3R+r9SrcgVqtQjpqPaSqfPN5kpF9WIryQJgqZSCZ/8bUjdFm
	vb1zl4jGsD6ew6oEoc87CETmxwUB97LqZPcI+D5hXYQy5zxHx53ShG/ToUh8XUSYm2wjWz
	c2jphbmX1pjSgYvS+CAVtJxvI4CQzkU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-BwgOkjYSP3yPFvJGGsXOtA-1; Thu,
 05 Dec 2024 09:44:44 -0500
X-MC-Unique: BwgOkjYSP3yPFvJGGsXOtA-1
X-Mimecast-MFC-AGG-ID: BwgOkjYSP3yPFvJGGsXOtA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37AFC1955EB3;
	Thu,  5 Dec 2024 14:44:43 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3090B1956094;
	Thu,  5 Dec 2024 14:44:40 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:39 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 0/7] trace-cmd: Fix misc issues uncoverd by static analysis
Date: Thu,  5 Dec 2024 15:44:32 +0100
Message-ID: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

More issues were found by running static analysers on the code
of trace-cmd with openscanhub[1].

[1] https://fedoraproject.org/wiki/OpenScanHub

Jerome Marchand (7):
  trace-cmd lib: Close FDs in create_buffer_recorder_fd2 it allocation
    fails
  trace-cmd lib: Prevent a memory leak in tracecmd_tsync_with_guest()
  trace-cmd lib: Prevent a leaked FD in
    __tracecmd_create_buffer_recorder()
  trace-cmd lib: Prevent memory leak in tracecmd_msg_wait_for_cmd()
  trace-cmd sqlhist: Initialize name in trace_sqlhist()
  trace-cmd: Fix memory leak in stop_mapping_vcpus()
  trace-cmd record: Fix stdin redirection to /dev/null

 lib/trace-cmd/trace-msg.c      |  4 +++-
 lib/trace-cmd/trace-recorder.c | 19 ++++++++++---------
 lib/trace-cmd/trace-timesync.c |  1 +
 tracecmd/trace-record.c        |  2 +-
 tracecmd/trace-sqlhist.c       |  2 +-
 tracecmd/trace-tsync.c         |  1 +
 6 files changed, 17 insertions(+), 12 deletions(-)

-- 
2.47.0

