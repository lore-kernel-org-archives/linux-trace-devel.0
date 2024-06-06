Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6314683
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688319; cv=none; b=Bho+q+ykzh7DQIUmIW88yReCfAgRWw4M1VAGv10gog2LAW5ouJy+n7kRn0kND/9B+FhzCRqEKKpzcx8eW599RwIbvb5/FJr6bCOzbJa50kQmpLHqX1VZVI/hdirq0oGnJYv32HnLc5xY8BeGlCvF0cphmfBSv1dnx98k/BivDwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688319; c=relaxed/simple;
	bh=XI4j20IxAzQOtQw4qh2808vxzQRtA022UX7EpVs9Hlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X6DtlTTuA1unpeSiO4vQww9Ek+rVe7RkEvnfhHQ9Q6YsruR/Q6LAkp6ND8l7aFXVgctWqF3H0uVIGGRvGVF0IHoZ2VMsEhQM+OEcf/FKZKQyYPLTY0QzpBUoSA6J3mTTB3ZR+khSCzoTPuoCIjn5OSFo3gkz2NLIfrNlog01Aqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8VKuByc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8VKuByc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tYPuT93iplYdo1pKmBTluWflAUjVUbtSn6qMqdarIxw=;
	b=T8VKuBycOOhCBIWw/S/d1O0ThalmWadtXXMmbvGD3MjlNVZ6y5wvoUIdkSIkG/NMBVw5oe
	qtKcD8F7O61TpqSKt1MuN5wo+H50maNjKbSSpj+0EeCXb5plsvEkXls48DGBT+Ig9V04sb
	9icZhzRIxwts/vASnD2tD8cBURU/B1I=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-R89k44tJMaSQQ0DjOyRN2A-1; Thu,
 06 Jun 2024 11:38:34 -0400
X-MC-Unique: R89k44tJMaSQQ0DjOyRN2A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E19B19560AE;
	Thu,  6 Jun 2024 15:38:33 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 50CB01955F4B;
	Thu,  6 Jun 2024 15:38:31 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:30 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 00/15] libtracefs: fix misc issues found by static analysis
Date: Thu,  6 Jun 2024 17:38:14 +0200
Message-ID: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

A number of issues were found by running static analysers on the code
of trace-cmd with openscanhub[1]. Mostly ressource leaks.

[1] https://fedoraproject.org/wiki/OpenScanHub

Jerome Marchand (15):
  libtracefs: call va_end() before exiting tracefs_hist_set_sort_key()
  libtracefs: prevent memory leak in append_filer()
  libtracefs: prevent a memory leak in update_fields()
  libtracefs: prevent a memory leak in tracefs_synth_add_end_field()
  libtracefs: prevent memory leak in tracefs_event_systems()
  libtracefs: don't leak socket file descriptor in open_vsock()
  libtracefs: prevent a memory leak in add_func_str()
  libtracefs: prevent a memory leak in tracefs_system_events()
  libtracefs: prevent a memory leak in open_cpu_files()
  libtracefs: prevent memory leak in tracefs_instance_create()
  libtracefs: my_yyinput() should return 0 when no data can be read
  libtracefs: prevent memory leak in tracefs_dynevent_get_all()
  libtracefs: close dir in the error path in tracefs_system_events()
  libtracefs: close dir in the error path in tracefs_event_systems()
  libtracefs: initialize val in build_filter()

 src/tracefs-dynevents.c |  1 +
 src/tracefs-events.c    | 21 ++++++++++-----------
 src/tracefs-filter.c    |  6 ++++--
 src/tracefs-hist.c      | 10 ++++++----
 src/tracefs-instance.c  |  1 +
 src/tracefs-sqlhist.c   |  6 +++---
 src/tracefs-tools.c     |  4 +++-
 src/tracefs-vsock.c     |  4 +++-
 8 files changed, 31 insertions(+), 22 deletions(-)

-- 
2.44.0

