Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACEC21A44D
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409910; cv=none; b=kJUE/Du6hPWAO2b0sIC44ZfUTMXAhdMcaSqA4gZBaCZRl9fVBJKS+u5I/1YT4QUJfe/9Cg+vGULmBkZlhARYNfvDVm5xW306iO+MDbho1aJM5QQmfkfhQQKRZmzWog5Rk3tsSLHyYkIsfvz0F2r/PtYiYqMzyy1kkxhZAhU/puM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409910; c=relaxed/simple;
	bh=IAYw2DWVn99YShE8yki5wZokd8EYANRZFVmYTdA7FfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hykCqqOpwvTC6sUSXrOJkvPJiMZqj/jP8BOmlxa8Wqf8qsHtB6QRWu3YRADKLZXp5LDbjGqC4dRUgYdtPGC1ax7DAYmjq9k4lFL2PqbPfywDzTuF48t/HPgeM21OYeGsFzKujNoXsQNUK0I1xoIVxqsby395AtBbRnW0XfpED2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8hUZLks; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8hUZLks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kRQQh58nAPA9dFbGMMGQ/G0/HFqr8fR/rn6VMKxj+00=;
	b=A8hUZLksOFcMxH85568nigK0euV+zFIpfQvKfyjHoainKJ2qvOTOx56RYVfEyqfmIPIQvL
	N9CEQ8GSCGZM5zAWQp8EDCPXgExwPNzXmkxJ9ZHkp74I8QniLMFVC6KX7G85eGXRYgvXKk
	EOK02QAS5c/N5PeyOCHga6gDY3nRohA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-HmJdrXHjMEiCkKNBPY2ykg-1; Thu,
 05 Dec 2024 09:45:06 -0500
X-MC-Unique: HmJdrXHjMEiCkKNBPY2ykg-1
X-Mimecast-MFC-AGG-ID: HmJdrXHjMEiCkKNBPY2ykg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B6CA1956048;
	Thu,  5 Dec 2024 14:45:04 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 89DA11956094;
	Thu,  5 Dec 2024 14:45:02 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:45:01 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 6/7] trace-cmd: Fix memory leak in stop_mapping_vcpus()
Date: Thu,  5 Dec 2024 15:44:38 +0100
Message-ID: <20241205144439.127564-7-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

In stop_mapping_vcpus(), tmap.vcpu is allocated in map_kvm_vcpus() but
not freed in the error path.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-tsync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 57baff39..834b4da4 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -258,6 +258,7 @@ static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
  out_free:
 	tep_free(tep);
  out:
+	free(tmap.vcpu);
 	free(tmap.map);
 	tracefs_instance_destroy(guest->instance);
 	tracefs_instance_free(guest->instance);
-- 
2.47.0

