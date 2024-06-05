Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F28194AC2
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594915; cv=none; b=b8G6CPhIJ6EdndkUpNbGR9rVXphFVUJylW4di+6yjKkM5l4XQt6XxU0VncLR69cdCzkSa05QGmDkOvb4JgaIFKMeaPXlcriO8q4amecqzd7Nxhc8XUOXAdteauTsPNbfdBOowyVq+UNZK7IeSuJsbvPQse7zLwEchs7l73LM5qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594915; c=relaxed/simple;
	bh=t65R1iG83VacrKuReY8A4ZSCSt+GnV/UiYaHWmXhSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMFqRcQQ87Srucwi2J9lJAyyQA2HcW1Su/PfuMhWm0pzF85wGpNHAqmlZsSeO7qFhTrxsxQKy9ZGyb03pZsjYh6gEAHlPw8OVO4CuWsw6kZBhjaW0akaG5I+pPq1QbZEDGLy09j5UkscSPggov86gpwStJlScvBDp3EEEelZWmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwaM4E+O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwaM4E+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thz4h3w64XIE8wlAoS+C9l2TPwCTB/0aMTSHmchxuMM=;
	b=fwaM4E+O5o8OBa1xavTUfZlMci38Tr0z6gXpRj7aeEszVRSke6haJCPMoPXG6zhLO0/ibQ
	q8DwfPP3amix4q6wVQP3NIVboLBOYIHoTnV5qb64lzeuNR4flpTqBPnplPF9C4cR4FW3bI
	DQ1YvxWdj99cJqYWePEpDlrf5AYX9Js=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-P20njlAGO9q_p3v41mciSw-1; Wed, 05 Jun 2024 09:41:50 -0400
X-MC-Unique: P20njlAGO9q_p3v41mciSw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F820185B920;
	Wed,  5 Jun 2024 13:41:49 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id B7D33492BE9;
	Wed,  5 Jun 2024 13:41:47 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:47 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 14/38] trace-cmd record: prevent memory leak in update_pid_filters()
Date: Wed,  5 Jun 2024 15:40:29 +0200
Message-ID: <20240605134054.2626953-15-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Free filter before exiting update_pid_filters()

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3e29f922..c4d43469 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2881,6 +2881,7 @@ static void update_pid_filters(struct buffer_instance *instance)
 	} while (ret >= 0 && len);
 
  out:
+	free(filter);
 	close(fd);
 }
 
-- 
2.44.0

